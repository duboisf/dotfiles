#!/bin/bash
 
# Load resources
xrdb -merge .Xresources
 
# swap caps lock and escape keys
xmodmap /home/fred/.Xmodmap

# use alt+shift to change keyboard layout between us and ca
/home/fred/bin/change_layout

# Set up an icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x000000 --alpha 0 --height 17 &

# Set the background color
xsetroot -solid midnightblue
 
# Fire up apps
 
# while true ; do date ; sleep 60 ; done | dzen2 -e '' -x 400 -w $off -ta r -fg $FG -bg $BG -p &

nm-applet &

exec ssh-agent dbus-launch --exit-with-session xmonad
