#!/bin/bash
#
#----------------------------------------------
#
# getXMobar.sh: Get a string with XMobar script
#               that we want to run.
#   Parameters:
#            . XMOBAR_TYPE: Kind of XMobar we 
#                           want. We have next
#                           types:
#                             . TOP panel.
#                             . MUSIC panel.
#
#            .  NUM_SCREEN: Screen counter we
#                           have.
#
#----------------------------------------------


#----------------------------------------------
# Config.
#
SCRIPT=`basename $0`
BASE="${0%/*}"
LOG="/home/nestorock/.xmonad/log/${SCRIPT%.*}.log"

XMOBAR="xmobar"
XMOBAR_CONFIG="/home/nestorock/.xmonad/xmobar/"
#
#----------------------------------------------


#----------------------------------------------
#    Function: RunEnabled
# Description: Check if we can run our script.
#
RUN_ENABLED=0
RunEnabled()
{
   returnCode=1
   if [ $RUN_ENABLED -eq 1 ]
   then
   	   returnCode=0
   fi

   return $returnCode
}
#
#----------------------------------------------


#----------------------------------------------
#    Function: CheckParam
# Description: Check if we have the right parameters.
#
NUM_PARAM=$#
CheckParam()
{
   returnCode=0
   if [ $NUM_PARAM -eq 2 ]
   then
       XMOBAR_MODE=$1
       NUM_SCREEN=$2

       returnCode=1
   fi

   return $returnCode
}
#
#----------------------------------------------


#----------------------------------------------
#  MAIN
#
# Check parameters
CheckParam $1 $2
RUN_ENABLED=$?

#if [ $(expr $RunENABLED) ]
             #sed 's/\[X\]/80/g' .xmobarrc_music ;;
if RunEnabled
then
    case "$XMOBAR_MODE" in
    	TOP) RUN_SCRIPT="echo xmobar -x $NUM_SCREEN .xmobarrc"
             xmobarTmp="xmobarrc" ;;
      MUSIC) xmobarConfig=$XMOBAR_CONFIG".xmobarrc_music"
             xmobarTmp=$XMOBAR_CONFIG".xmobarrc_music_tmp"
             case $NUM_SCREEN in
                1) sed 's/\[X\]/0/g'    $xmobarConfig > $xmobarTmp ;;
                2) sed 's/\[X\]/1280/g' $xmobarConfig > $xmobarTmp ;;
             esac
             RUN_SCRIPT=$XMOBAR" "$xmobarTmp ;;
          *) RUN_ENABLED=0 ;;
    esac
fi

#----------------------------------------------


#----------------------------------------------
# Script to get selected XMobar.
echo ""                                  >> $LOG
echo "---------------------------------" >> $LOG
date                                     >> $LOG
echo "---------------------------------" >> $LOG

echo "     path: [$BASE]"                >> $LOG
echo "      log: [$LOG]"                 >> $LOG
echo " Starting: [$SCRIPT]"              >> $LOG
echo "  Screens: [$NUM_SCREEN]"          >> $LOG
echo "     Mode: [$XMOBAR_MODE]"         >> $LOG
echo ""

#----------------------------------------------
# Run script.
if RunEnabled
then
    echo "RunScript: ["$RUN_SCRIPT"]"    >> $LOG
    ps -ef | pgrep -f "$xmobarTmp" | awk '{ system("kill -9 "$0) }'  >> $LOG
    sleep 0.5
    $RUN_SCRIPT &
else
    echo "RunScript: [DISABLE]"          >> $LOG
fi
#xmobar .xmobarrc2

