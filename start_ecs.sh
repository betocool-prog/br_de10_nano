#!/bin/bash

# Script for automating handoff file generation
# using embedded console and U-Boot

# Assume version 20.1 for intelFPGA embedded console
IF_VER="20.1"
echo "Assuming intelFPGA version ${IF_VER}"

# Store current folder location!
# Into CURR_DIR
CURR_DIR=`pwd`
echo "Current Folder: ${CURR_DIR}"

# Check for intelFPGA folder
#	Check in ~/opt
#		Store folder
#   Check in ~/
#		Store folder
# Otherwise exit
if [ -d ~/opt/intelFPGA/${IF_VER}/embedded ]
then
	EMBEDDED_CONSOLE_DIR=~/opt/intelFPGA/${IF_VER}/embedded
	echo "Found intelFPGA Embedded console in: ${EMBEDDED_CONSOLE_DIR}"
elif  [ -d ~/intelFPGA/${IF_VER}/embedded ]
then
	EMBEDDED_CONSOLE_DIR=~/intelFPGA/${IF_VER}/embedded
	echo "Found intelFPGA Embedded console in: ${EMBEDDED_CONSOLE_DIR}"
else
	echo "intelFPGA embedded not found!"
 	exit 1
fi

# Launch embedded command shell
${EMBEDDED_CONSOLE_DIR}/embedded_command_shell.sh
if [ "$?" -ne "0" ]
then
	echo "Error calling embedded command shell. Exiting... "
	cd ${CURR_DIR}
	exit 1
fi

cd ${CURR_DIR}
