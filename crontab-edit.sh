#!/bin/sh
# Add or remove lines from cronjob
# based on https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor
# NOTE: this script does not allow duplicate commands in the crontab.
cronjob_editor () {         
# usage: crontab-edit.sh '<interval>' '<command>' <add|remove>

if [[ -z "$1" ]] ;then printf " no interval specified\n" ;fi
if [[ -z "$2" ]] ;then printf " no command specified\n" ;fi
if [[ -z "$3" ]] ;then printf " no action specified\n" ;fi

if [[ "$3" == add ]] ;then
    # add cronjob, no duplication:
    ( crontab -l | grep -v -F -w "$1 $2" ; echo "$1 $2" ) | crontab -
elif [[ "$3" == remove ]] ;then
    # remove cronjob:
    ( crontab -l | grep -v -F -w "$1 $2" ) | crontab -
fi 
} 

cronjob_editor "$1" "$2" "$3"