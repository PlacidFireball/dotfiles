#! /usr/bin/zsh
nm-applet & # start network-manager-applet in the background
/usr/bin/dbus-send --session --type=method_call --dest=org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.Lock &
