#!/bin/bash
 
nm-applet --sm-disable &

# Load resources
xrdb -merge .Xresources
 
# use alt+shift to change keyboard layout between us and ca
setxkbmap -option grp:switch,grp:alt_shift_toggle us,ca

# swap caps lock and escape keys
# xmodmap /home/fred/.Xmodmap

# Set up an icon tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x000000 --alpha 0 --height 17 &

# Set the background color
xsetroot -solid midnightblue
 
# Fire up apps
 
# while true ; do date ; sleep 60 ; done | dzen2 -e '' -x 400 -w $off -ta r -fg $FG -bg $BG -p &

# load gtk theme, xmodmap and stuff
gnome-settings-daemon &

sleep 1s

exec ssh-agent dbus-launch --exit-with-session xmonad
