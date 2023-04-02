#!/bin/bash
###########
# Check if "downloads" folder exists

if [[ ! -d ./downloads ]]
then
    echo "Creating downloads folder..."
    mkdir ./downloads
fi

BR_FOLDER="~/opt/buildroot-2022.11.3"

make -C $BR_FOLDER BR2_EXTERNAL=/media/disk_512gb/Buildroot/br_de10_nano O=/media/disk_512gb/Buildroot/br_de10_nano \
	BR2_DL_DIR=/media/disk_512gb/Buildroot/br_spec/downloads terasic_de10nano_cyclone5_defconfig

