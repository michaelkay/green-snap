# Overview
greensnap is a set of shell scripts that create timelapse and security camera videos. Setup is easy but does require some knowledge of the Linux command prompt.

For a full description see this post http://raspberrypimaker.com/simple-security-camera/

## Prerequesits
These scripts run on most Linux systems including the RaspberryPi. The Raspi camera is supported.
- Some type camera. Webcams, IP cameras and the RaspberryPi camera is supported
- ffmpeg
- fswebcam (only needed for webcams)
- raspistill (only for the raspi cam)
- dropbox-uploader (see below)

### Installing ffmpeg
The latest versions of Raspbian and Debian include ffmpeg as a package. To install
`sudo apt-get install ffmpeg`

### Installing fswebcam
Please see [this webpage](https://www.raspberrypi.org/documentation/usage/webcams/)

### Installing raspistill
raspistill should be included with the camera software. See [this page for more information](https://www.raspberrypi.org/documentation/raspbian/applications/camera.md)

### Installing drpbox-uploader
If you would like the scripts to automatically upload images and/or videos to DropBox you will need the `dropbox-uploader.sh` script. Download the script with this command
`curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh`
And then 
`chmod +x dropbox_uploader.sh`
Run the script once to setup the access key. For more information [see this web page](https://github.com/andreafabrizi/Dropbox-Uploader)
NOTE: The `dropbox_uploader.sh` needs to be in the same directory as the other scripts in this package. It will not work if you put it in a central place and add it to the path. Sorry.

## Installation
1. Create a dedicated folder for your images and videos
1. Clone the git repository or download and unzip
1. Change the scripts to have the execute attribute `chmod +x *.sh`
1. Thats it!

# Use
It is required that each camera have a dedicated directory folder to store the images. Also, please a copy of all scripts (including dropbox-uploader.sh) into each folder.
**gsnap.sh** will snap an image from a camera. The image is saved in the current directory.
**movie.sh** will take a collection of timestamped images and convert them to a video file.
**crontab-edit.sh** adds lines to the crontab scheduling image snaps, movie creation and Dropbox uploads
**gsnap-cleanup.sh** adds lines to the crontab to cleanup (delete) old images and movies
