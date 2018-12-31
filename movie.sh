#!/bin/sh
# movie.sh
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

# Default values set here
DT=`date +%y%m%d%H%M`
name=''
delta="-mtime 1"
framerate="12"
while [ "$#" -gt 0 ]; do
  case "$1" in
    -n) name="$2"; shift 2;;
	-l) location="$2"; shift 2;;
	-d) delta="-mtime -$2"; shift 2;;
	-m) delta="-mmin -$2"; shift 2;;
	-db) dbox="1"; shift 1;;
	-f) framerate="$2"; shift 2;;

    --name=*) name="${1#*=}"; shift 1;;
    --location=*) location="${1#*=}"; shift 1;;
    --days=*) delta="-mtime ${1#*=}"; shift 1;;
    --mins=*) delta="-mmin ${1#*=}"; shift 1;;
    --framerate=*) framerate="${1#*=}"; shift 1;;
	--dbox) dbox="1"; shift 1;;
    --name|--location|--days|--mins|--framerate) echo "$1 requires an argument" >&2; exit 1;;
	
	--help) echo "movie.sh - take date coded images and convert to a timelapse mp4"; echo ;
			echo "  -n, --name - set the filename prefile. If omitted just the datecode will be used";
			echo "  -l, --location - set the directory location for the original images and where the mp4 will go";
			echo "  -d, --days - get images from the last n days for the movie. Default is 1 day";
			echo "  -m, --mins - get images from the last n minutes for the movie (will cancel -d option)";
			echo "  -f, --framerate - sets frames per second. The default is 12 which will give a 2 minute film if images are snapped every minute for a day";
			echo "  -db, --dbox - After movie is created, upload to dropbox (requires dropbox_uploader)";
			echo "  --help - this help info"; 
			echo ; echo "NOTE: limit the files in --location to a single camera. This script pulls all images for the movie.";	exit 1;;

    -*) echo "unknown option: $1" >&2; exit 1;;
    *) args="${args}$1 "; shift 1;;
  esac
done

if [ -z "$location" ]; then echo 'ERROR - Location must be set'; exit 1; fi
DT=`date +%Y%m%d%H%M%S`

cd $location
if [ ! -d /tmp/camera ]; then mkdir /tmp/camera; fi
if [ ! -d /tmp/camera/$name$DT ]; then mkdir /tmp/camera/$name$DT; fi
find $location/*.jpg $delta -exec ln -s {} /tmp/camera/$name$DT/ \;
ffmpeg -f image2 -pattern_type glob -framerate $framerate -i "/tmp/camera/$name$DT/*.jpg" -c:v mpeg4 -q:v 20 -an ./$name$DT.mp4
if [ ! -z "$dbox" ]; then ./dropbox_uploader.sh upload ./$name$DT.mp4 $name$DT.mp4; fi
