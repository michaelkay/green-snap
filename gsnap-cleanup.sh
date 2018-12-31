#!/bin/sh
# Add lines to crontab to remove older jpg and mp4 files
# based on https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor
# NOTE: this script does not allow duplicate commands in the crontab.
#
# (c)2019 The Green Island Companies LLC
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Designed for use on the Raspberry Pi. Find out more at
# http://raspberrypimaker.com
#
# Developed by
# Green Island Companies - http://greenislandcompanies.com
#
cronjob_editor () {         
# usage: crontab-edit.sh '<interval>' '<command>' <add|remove>

if [ -z "$1" ] ;then printf " no interval specified\n" ;fi
if [ -z "$2" ] ;then printf " no command specified\n" ;fi
if [ -z "$3" ] ;then printf " no action specified\n" ;fi

if [ "$3" = "add" ] ;then
    # add cronjob, no duplication:
    ( crontab -l | grep -v -F -w "$1 $2" ; echo "$1 $2" ) | crontab -
elif [ "$3" = "remove" ] ;then
    # remove cronjob:
    ( crontab -l | grep -v -F -w "$1 $2" ) | crontab -
fi 
} 

if [ -z $1 ]; then 
  mtime="7"
else
  mtime=$1
fi

# first remove the entries for this directory
( crontab -l | grep -v -F -w "@daily find $PWD/*.jpg -mtime" ) | crontab -
( crontab -l | grep -v -F -w "@daily find $PWD/*.mp4 -mtime" ) | crontab -
# add updated/new lines
cronjob_editor "@daily" "find $PWD/*.jpg -mtime +$mtime -exec rm {} \; #Remove old camera jpg images" "add"
cronjob_editor "@daily" "find $PWD/*.mp4 -mtime +$mtime -exec rm {} \; #Remove old camera mp4 movies" "add"
