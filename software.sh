#!/bin/sh

GIT_DIR 	= "/home/pi/git"
BIN_DIR 	= "/home/pi/bin"
SCRIPT_DIR 	= "/home/pi/script"
MOTION_DIR	= "/home/pi/.motion"

# This script must be run as root. 
if [ "$EUID" -ne 0 ]; then

	# If it is not, terminate.
	echo "Please run as root"
	exit
	
else

	# Make directory to store git files
	if [ ! -d $GIT_DIR ]; then
		mkdir $GIT_DIR
	fi
`	
	# Make directory to store bin files
	if [ ! -d $BIN_DIR ]; then
		mkdir $BIN_DIR
	fi
	
	# Make directory to store scripts
	if [ ! -d $SCRIPT_DIR ]; then
		mkdir $SCRIPT_DIR
	fi
	
	# Make directory to store config files for Motion
	if [ ! -d $MOTION_DIR ]; then
		mkdir $MOTION_DIR
	fi

	cd $GIT_DIR

	# Install the software that serves the video from the FLIR Lepton Module to a device 
	# file. The software is stored on GitHub and can be compiled using a simple makescript. 
	# The resulting binary can then be copied to a folder where it is more convenient to use.
	git clone https://github.com/groupgets/LeptonModule.git
	make -C ./software/v4l2lepton
	cp ./software/v4l2lepton/v4l2lepton $BIN_DIR

	# Install the software that creates a device file that accepts the video from the FLIR Lepton
	# Module. The software is stored on GitHub and can be compiled using a simple makescript.
	# The result is a kernel module that must be installed for proper use.
	git clone https://github.com/umlaeute/v4l2loopback.git
	make 
	make install
	
	# Install Motion which is the piece of software that will read video from the device file and
	# stream images across a network. The software is stored in the standard repositories where
	# it can be accessed easily.
	sudo --assume-yes apt-get install motion
	
	# Get the script used to execute all programs from GitHub.
	git clone https://github.com/siuthunderdawgs/rpi-motion-script.git
	cp ./motion_script/* $SCRIPT_DIR
	
	# Get the script used to configure Motion from GitHub.
	git clone https://github.com/siuthunderdawgs/rpi-motion-config.git
	cp ./motion_config/* $MOTION_DIR
	
	cd $SCRIPT_DIR
	
fi
