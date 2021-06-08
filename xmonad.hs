import XMonad

import qualified XMonad.Core as Core
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Layout.ThreeColumns
-- TODO: GHC can't find 'TwoPanePersistent'. Figure out why and replace
-- 'Tall' by 'TwoPanePersistent'
-- import XMonad.Layout.TwoPanePersistent

import XMonad.Hooks.EwmhDesktops

-- Xmobar support
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

-- Bring volume key codes into scope
import Graphics.X11.ExtraTypes.XF86

-- 2D window navigation
import XMonad.Actions.Navigation2D


import System.Exit (exitWith, ExitCode(ExitSuccess))

main :: IO ()
main = statusBar "xmobar" myXmobarPP toggleStrutsKey myConfig >>= xmonad . ewmh
  where
    myConfig = navigation2D def
                            (xK_u, xK_n, xK_e, xK_i)
                            [ (myModMask              , windowGo  )
                            , (myModMask .|. shiftMask, windowSwap)
                            ]
                            True
              $ baseConfig

    baseConfig = def { modMask         = myModMask
                   , keys            = myKeys
                   , layoutHook      = myLayouts
                   , handleEventHook = handleEventHook def <+> docksEventHook

                   -- Border setup.
                   , borderWidth        = 7
                   , focusedBorderColor = purple
                   , normalBorderColor  = darkPurple
                   }

    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)

    purple     = "#ee46fa"
    darkPurple = "#620169"

    myXmobarPP = def
      { ppSep             = " | "
      , ppTitleSanitize   = xmobarStrip
      , ppTitle           = fPurple
      , ppCurrent         = wrap (fRed "[") (fRed "]")
      , ppHidden          = fWhite . wrap " " ""
      , ppUrgent          = fRed . wrap (fYellow "!") (fYellow "!")
      }
      where
        -- String formatters for xmobar
        fMagenta = xmobarColor "#ff79c6" ""
        fWhite   = xmobarColor "#f8f8f2" ""
        fYellow  = xmobarColor "#f1fa8c" ""
        fRed     = xmobarColor "#ff5555" ""
        fPurple  = xmobarColor purple ""

    myModMask = mod4Mask   -- We use the Super key (a.k.a Windows key) as Mod mask.

    -- We remap all the Xmonad default keys.
    --
    -- See xmonad.Xmonad.Config
    myKeys conf
      = let cModMask = modMask conf in
        M.fromList
      $ [ ((cModMask .|. shiftMask, xK_Return), spawn $ Core.terminal conf) -- %! Launch terminal
        , ((cModMask,               xK_r     ), spawn "dmenu_run") -- %! Launch dmenu
        , ((cModMask .|. shiftMask, xK_r     ), spawn "gmrun") -- %! Launch gmrun
        , ((cModMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window

        , ((cModMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
        , ((cModMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

        , ((cModMask,               xK_d     ), refresh) -- %! Resize viewed windows to the correct size

        -- move focus up or down the window stack
        , ((cModMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
        , ((cModMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
        --, ((cModMask,               xK_e     ), windows W.focusDown) -- %! Move focus to the next window
        -- , ((cModMask,               xK_n     ), windows W.focusUp  ) -- %! Move focus to the previous window
        , ((cModMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

        -- modifying the window order
        , ((cModMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
        -- We configure these through 'XMonad.Actions.Navigation2D'
        -- , ((cModMask,               xK_u     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
        -- , ((cModMask,               xK_l     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

        -- resizing the master/slave ratio
        , ((cModMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
        , ((cModMask,               xK_o     ), sendMessage Expand) -- %! Expand the master area

        -- floating layer support
        , ((cModMask,               xK_z     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

        -- increase or decrease number of windows in the master area
        , ((cModMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
        , ((cModMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

        -- quit, or restart
        , ((cModMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
        , ((cModMask              , xK_q     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad

        -- take a screenshot
        , ((cModMask, xK_j), spawn "maim --select | xclip -selection clipboard -t image/png")

        -- Notifications
        , ((cModMask, xK_backslash), spawn "dunstctl close-all")
        , ((cModMask, xK_quoteright), spawn "dunstctl history-pop")

        -- Audio input/output control
        , ((cModMask, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1%")
        , ((cModMask, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1%")
        , ((cModMask, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        ]
      ++
      -- mod-[1..9] %! Switch to workspace N
      -- mod-shift-[1..9] %! Move client to workspace N
      [((m .|. cModMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
      ++
      -- We're not gonna be making use of these
      -- [((m .|. cModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      -- | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      -- , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
      --
      [ ((cModMask, xK_l), screenWorkspace 1 >>= flip whenJust (windows . W.view))
      , ((cModMask, xK_y), screenWorkspace 0 >>= flip whenJust (windows . W.view))
      , ((cModMask .|. shiftMask, xK_l), screenWorkspace 1 >>= flip whenJust (windows . W.shift))
      , ((cModMask .|. shiftMask, xK_y), screenWorkspace 0 >>= flip whenJust (windows . W.shift))
      ]

    myLayouts
      =   Tall     1 delta (1/2)
      ||| ThreeCol 1 delta (4/10)
      ||| Full
      where
        -- Default proportion of screen occupied by master pane
        ratio   = 1/2
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
