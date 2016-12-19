#!/bin/bash

# Custom dmenu for exit.
#
HEIGHT="15"
FN="snap"
NF="#505050"
NB="#000000"
SF="#ffb964"
SB="#000000"
OPTIONS="-b -i -l $HEIGHT -fn $FN -nf $NF -nb $NB -sf $SF -sb $SB"

MENU="dmenu-4.6"
#MENU="/home/nestorock/Documents/dmenu-5cd66e2c6ca6a82e59927d495498fa6e478594d6/dmenu"
#MENU="rofi -dmenu"

choice=`echo -e "0: Cancel\n1: Logout\n2: Reboot\n3: Shutdown\n4: Lock" | $MENU -p "select an action:" $OPTIONS | cut -d ':' -f 1`

case "$choice" in
0) exit ;;
1) xdotool key Home+q ;;
2) /sbin/reboot ;;
3) /sbin/shutdown now ;;
4) slock ;;
esac
