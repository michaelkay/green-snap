#!/bin/sh
# gsnap.sh
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
name=''
netcam="1"
skip="1"
delay="3"
while [ "$#" -gt 0 ]; do
  case "$1" in
    -n) name="$2"; shift 2;;
    -c) camera="$2"; shift 2;;
	-r) resolution="$2"; shift 2;;
	-s) skip="$2"; shift 2;;
	-d) delay="$2"; shift 2;;
	-R) rotate="$2"; shift 2;;
	-w) webcam="1"; netcam=""; shift 1;;
	-rc) raspicam="1"; webcam=""; netcam=""; shift 1;;
	-db) dropbox="1"; shift 1;;
	-DB) dropbox="1"; fdelete="1"; shift 1;;

    --name=*) name="${1#*=}"; shift 1;;
    --camera=*) camera="${1#*=}"; shift 1;;
    --resolution=*) resolution="${1#*=}"; shift 1;;
    --rotate=*) rotate="${1#*=}"; shift 1;;
    --skip=*) skip="${1#*=}"; shift 1;;
    --delay=*) delay="${1#*=}"; shift 1;;
	--webcam) raspicam=""; webcam="1"; netcam=""; shift 1;;
	--raspicam) raspicam="1"; webcam=""; netcam=""; shift 1;;
	--dropbox=*) dropbox="1"; dropboxdir="${1#*=}/"; shift 1;;
	--DROPBOX=*) dropbox="1"; dropboxdir="${1#*=}/"; fdelete="1"; shift 1;;
    --name|--camera|--resolution|--skip|--delay|--rotate|--dropbox|--DROPBOX) echo "$1 requires an argument. type snap.sh --help for help" >&2; exit 1;;
	
	--help) echo "gsnap.sh - take a since date coded image"; echo ;
			echo "  -c, --camera - set the rtsp:// camera url or webcam path (required for rtsp and webcam)";
			echo "  -w, --webcam - Capture from a web cam";
			echo "  -rc, --raspicam - Capture from a raspicam cam";
			echo "  -n, --name - set the filename prefix. If omitted just the datecode will be used";
			echo "  -r, --resolution - sets the captured resolution (webcam and raspi cam only)";
			echo "  -s, --skip - Skip n frames allowing the camera time to power on (webcam only)";
			echo "  -d, --delay - delay n seconds before capture. Allows camera to set up auto white balance";
			echo "  -R, --rotate - Rotate the image n degrees (webcam & raspicam only)";
			echo "  -db - Copy jpg to DropBox default app directory";
			echo "  -DB - Copy jpg to DropBox default app directory and then delete local copy";
			echo "  --dropbox=dir - Copy jpg to DropBox 'dir' under app directory";
			echo "  --DROPBOX=dir - Copy jpg to DropBox 'dir' under app directory and delete local copy";
			echo "  --help - this help info"; exit 1;;

    -*) echo "unknown option: $1" >&2; exit 1;;
    *) args="${args}$1 "; shift 1;;
  esac
done

if [ -z "$raspicam" ]
then
if [ -z "$camera" ]; then echo 'ERROR - Camera loctation must be set'; exit 1; fi
fi

if [ ! -z "$netcam" ]
then 
  if [ ! -z "$delay" ]; then delay="-ss $delay"; fi
fi

if [ ! -z "$webcam" ]
then 
  if [ ! -z "$resolution" ]; then resolution="-r $resolution"; fi
  if [ ! -z "$rotate" ]; then rotate="--rotate $rotate"; fi
  if [ ! -z "$skip" ]; then skip="-S $skip"; fi
  if [ ! -z "$delay" ]; then delay="-D $delay"; fi
fi

if [ ! -z "$raspicam" ]
then
  if [ ! -z "$resolution" ]; then resolution="-w ${resolution%x*} -h ${resolution#*x}"; fi
  if [ ! -z "$rotate" ]; then rotate="-rot $rotate"; fi
fi

DT=`date +%Y%m%d%H%M%S`
if [ ! -z "$netcam" ]; then nice ffmpeg -rtsp_transport tcp -i $camera $delay -vframes 1 ./$name$DT.jpg; fi
if [ ! -z "$webcam" ]; then fswebcam -d $camera $resolution $skip $delay $rotate -q ./$name$DT.jpg; fi
if [ ! -z "$raspicam" ]; then raspistill $resolution $rotate -o ./$name$DT.jpg; fi

if [ ! -z "$dropbox" ]; then ./dropbox_uploader.sh upload ./$name$DT.jpg $dropboxdir$name$DT.jpg; fi
if [ ! -z "$fdelete" ]; then rm ./$name$DT.jpg; fi

# fswebcam options
# -d, --device
# -r, --resolution
# -F, --frames
# -S, --skip
# -D, --delay
# --jpeg <factor>
# --rotate <angle>
# -q, --quiet
