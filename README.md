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

# Multiple monitors

You might need to setup the displays using xrandr. There's a visual
configuration tool that creates the xrand command in a shell script.

```sh

```

In large monitors you might want to add Xft.dpi options in Xresources.

```sh
ln -s ~/github/dnadales/xmonad-setup/.Xresources ~/
```
