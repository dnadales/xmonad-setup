# xmonad-setup
My Xmonad setup

Talk about the principles-behind and/or needed-ingredients-to-run xmonad.

## Build and install Xmonad

TODO: make sure to version the `xmonad` and `xmonad-contrib` revisions that are
known to work. Otherwise performing a git update on the (ignored) `xmonad` and
`xmonad-contrib` directories might cause that we lose the latest stable
version.

```sh
mkdir ~/.config/xmonad
```

Install `suckless-tools`.

```sh
sudo apt-get install suckless-tools
```

Install trayer

```
sudo apt install trayer
```

```
sudo apt install xscreensaver
sudo apt install xfce4-power-manager
sudo apt-get install nm-tray
```

Link the build necessary files.

```sh
ln -s $(pwd)/build ~/.config/xmonad/
ln -s $(pwd)/xmonad.hs ~/.xmonad/
ln -s $(pwd)/start-xmonad ~/.xmonad/
```

# Desktop notifications

Install dunst.

For notifications to work on chrome you need to enable the native notifications
flag.

# Multiple monitors

You might need to setup the displays using xrandr. There's a visual
configuration tool that creates the xrand command in a shell script.

```sh
arandr
```

In large monitors you might want to add Xft.dpi options in Xresources.

```sh
ln -s ~/github/dnadales/xmonad-setup/.Xresources ~/
```

## Hot plugging multiple monitors

This can be easily managed with `autorandr`, although it requires some initial
setup using `xrandr` (or `arandr`).

First configure the monitors using `xrandr` and then save the configuration by
running:

```sh
autorandr --save $SOME_NAME
```

This will list the detected configuration. E.g.:

```text
two-displays (detected) (current)
```

Plug and/or unplug monitors, configure them with `xrand`, and finally save the
configuration as described above. Once all desired configurations are saved the
system will automatically switch between them when monitors are plugged and/or
unplugged.

# Xmobar configuration

TODO: We should configure Xmobar in haskell.

```sh
ln -s $(pwd)/xmobarrc ~/.xmobarrc
stack install --flag xmobar:with_xft
```

# Compose key

Change it temporarily:

```sh
setxkbmap -option "compose:ralt"
```

Change it permanently:

```sh
echo '/usr/bin/setxkbmap -option "compose:ralt"' >> ~/.xsessionrc
```

# Pulse audio

sudo cp pulseaudio/relocate-audio-devices.sh /usr/local/bin
