#!/bin/bash
 
# Load resources
xrdb -merge .Xresources
 
# swap caps lock and escape keys
xmodmap .Xmodmap

# use alt+shift to change keyboard layout between us and ca
change_layout

# Set up an icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 5 --transparent true --tint 0x191970 --height 12 &
 
# Set the background color
xsetroot -solid midnightblue
 
# Fire up apps
 
# trayer --transparent true --widthtype request --height 18 --align right --edge top --expand true &

# while true ; do date ; sleep 60 ; done | dzen2 -e '' -x 400 -w $off -ta r -fg $FG -bg $BG -p &

exec ssh-agent dbus-launch --exit-with-session xmonad
