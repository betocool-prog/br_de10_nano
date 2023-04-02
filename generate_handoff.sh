#!/bin/bash

# Script for automating handoff file generation
# using embedded console and U-Boot

# Useful folder definitions. Change if necessary
PRJ_DIR=~/Projects
QPF_DIR=${PRJ_DIR}/
QSYS_DIR=system

# Store current folder location!
# Into CURR_DIR
CURR_DIR=`pwd`
echo "Current Folder: ${CURR_DIR}"

# Check our project folder exists or if not create it
if [ ! -d  ${PRJ_DIR} ]
	then
		mkdir ${PRJ_DIR}
		if [ "$?" -ne "0" ]
		then
			echo "Error creating ${PRJ_DIR} folder... check permissions?"
			exit 1
		fi
		echo "Created ${PRJ_DIR} folder"
fi

# Check for U-Boot 2020.10
# Otherwise try to clone it
# Otherwise exit

U_BOOT_DIR="${PRJ_DIR}/u-boot"
QTS_FILT_DIR="${U_BOOT_DIR}/arch/arm/mach-socfpga"

if [ -d "${U_BOOT_DIR}" ]
then
	echo "Found U-Boot: ${U_BOOT_DIR}"
	cd "${U_BOOT_DIR}"
	echo ""
	echo "### GIT Status"
	git status -v
	echo ""
	echo "### GIT Branch"
	git branch -v
else
	echo "Could not find U-Boot in ${U_BOOT_DIR}/"
	cd ${PRJ_DIR}
	
	echo "Cloning U-Boot into ${PRJ_DIR}"
	git clone https://source.denx.de/u-boot/u-boot.git
	if [ "$?" -ne "0" ]
	then
		echo "Error calling git... make sure it is installed!"
		exit 1
	fi
	cd "${U_BOOT_DIR}"

	echo "Checking out U-Boot v2020.10"

	git checkout v2020.10
	if [ "$?" -ne "0" ]
	then
		echo "Error checking out v2020.10"
		exit 1
	fi
fi

# Check for FPGA folder QPF_DIR
if [ ! -d "${QPF_DIR}" ]
then
	echo "Quartus project folder ${QPF_DIR} not found! Exiting..."
	exit 1
fi

# Navigate to quartus project folder
cd ${QPF_DIR}
# Make sure the ./build folder exists
if [ ! -d "${QPF_DIR}/build" ]
then
	mkdir build
fi

# Make sure the ./qts folder exists
if [ ! -d "${QPF_DIR}/qts" ]
then
	mkdir qts
fi
BUILD_DIR=${QPF_DIR}/build
QTS_DIR=${QPF_DIR}/qts

# Call bsp-create-settings
bsp-create-settings --type spl  --bsp-dir build --preloader-settings-dir ./hps_isw_handoff/${QSYS_DIR}_hps_0/ --settings build/settings.bsp
if [ "$?" -ne "0" ]
then
	echo "Error calling bsp-create-settings. Exiting... "
	cd ${CURR_DIR}
	exit 1
fi

# Generate handoff files for u-boot
${QTS_FILT_DIR}/qts-filter.sh cyclone5 ${QPF_DIR} ${BUILD_DIR} ${QTS_DIR}
if [ "$?" -ne "0" ]
then
	echo "Error calling qts-filter.sh"
	cd ${CURR_DIR}
	exit 1
fi

# If all went well, we're all good.
cd ${CURR_DIR}

echo
echo "Handoff files generated in ${QTS_DIR}"
echo

exit 0
