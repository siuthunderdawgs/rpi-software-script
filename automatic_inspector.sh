#!/bin/sh

GIT_DIR 	= "~/git"
BIN_DIR 	= "~/bin"

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
	
	cd $GIT_DIR
	
	# In order to make the project, a copy of the GCC toolchain must be available. This toolchain
	# can be downloaded and installed from the standard repository.
	apt-get --assume-yes install build-essential pkg-config
	
	# In order to make the project, a copy of two libraries must be available. The libraries
	# can be downloaded and installed from the standard repository.
	apt-get --assume-yes install libopencv-dev libconfig++-dev	
	
	# Clone the project from GitHub and compile the code.
	git clone https://github.com/siuthunderdawgs/automatic-inspector.git
	make -C ./automatic-inspector
	
	# Move the program to a standard binary folder.
	cp ./automatic-inspector/automatic_inspector $BIN_DIR
	
fi
