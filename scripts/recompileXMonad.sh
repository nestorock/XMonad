#!/bin/bash
#
#----------------------------------------------
#
# recompileXMonad.sh:
#        Kill all xmobar process, recompile and
#        restart xmobar
#
#   Parameters:
#            . N/A
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
SCRIPT_RECOMPILE_XMONAD=$XMONAD_PROCESS" --recompile"
SCRIPT_RESTART_XMONAD=$XMONAD_PROCESS" --restart"
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

#----------------------------------------------
# Run scripts.
echo "Running: [$SCRIPT_KILL_XMOBAR]"      >> $LOG
$SCRIPT_KILL_XMOBAR                        >> $LOG

echo "Running: [$SCRIPT_RECOMPILE_XMONAD]" >> $LOG
$SCRIPT_RECOMPILE_XMONAD                   >> $LOG

echo "Running: [$SCRIPT_RESTART_XMONAD]"   >> $LOG
$SCRIPT_RESTART_XMONAD                     >> $LOG
