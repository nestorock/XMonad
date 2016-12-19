#!/bin/bash
#
#----------------------------------------------
#
# toggleDisplayXMonad.sh:
#        Check if System has One or Two Monitors
#        and setup XMonad with One or Two Screens.
#        Then Kill all xmobar process, set again 
#        the background picture and restart XMonad.
#
#   Parameters:
#            . SCREENS counter.
#
#----------------------------------------------


#----------------------------------------------
# Config.
#
SCRIPT=`basename $0`
BASE="${0%/*}"
LOG="/home/nestorock/.xmonad/log/${SCRIPT%.*}.log"

XMONAD_PROCESS="xmonad"
XMONAD_PATH_SCRIPT="/home/nestorock/.xmonad/scripts/"

SCRIPT_KILL_XMOBAR=$XMONAD_PATH_SCRIPT"killXmobar.sh"
#SCRIPT_RECOMPILE_XMONAD=$XMONAD_PROCESS" --recompile"
SCRIPT_RESTART_XMONAD=$XMONAD_PROCESS" --restart"

SCREENS_COUNTER=$1
#
#----------------------------------------------


#----------------------------------------------
#  MAIN
#
# Script to get selected XMobar.
#
echo ""                                  >> $LOG
echo "---------------------------------" >> $LOG
date                                     >> $LOG
echo "---------------------------------" >> $LOG

echo "     path: [$BASE]"                >> $LOG
echo "      log: [$LOG]"                 >> $LOG
echo " Starting: [$SCRIPT]"              >> $LOG
echo ""
echo "  Screens: [$SCREENS_COUNTER]"     >> $LOG

#----------------------------------------------
# Run scripts.
# Check if Syste has One or more Screens.
SCRIPT_XRANDR_1="xrandr --output DP1 --off"
SCRIPT_XRANDR_2="xrandr --output HDMI1 --primary --mode 1920x1200"
if [ $SCREENS_COUNTER -eq 1 ]
then
    SCRIPT_XRANDR_1="xrandr --output HDMI1 --primary --mode 1920x1200 --right-of DP1 --output DP1 --mode 1280x1024"
    SCRIPT_XRANDR_2=""
fi

echo "Running: [$SCRIPT_XRANDR_1]"       >> $LOG
echo "         [$SCRIPT_XRANDR_2]"       >> $LOG
$SCRIPT_XRANDR_1; $SCRIPT_XRANDR_2       >> $LOG

echo "Running: [$SCRIPT_KILL_XMOBAR]"    >> $LOG
$SCRIPT_KILL_XMOBAR                      >> $LOG

echo "Running: [$SCRIPT_RESTART_XMONAD]" >> $LOG
sleep 2
$SCRIPT_RESTART_XMONAD                   >> $LOG
