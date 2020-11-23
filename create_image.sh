#!/bin/bash

sd_card_device=/dev/sdc
image_file=2020-08-20-raspios-buster-armhf-lite.img

# Ensure the user is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root..."
  exit
fi

# Write image file to SD card
echo "Writing image to SD card..."
dd if=$image_file of=$sd_card_device bs=1M status=progress
sync

# Make sure all partitions are unmounted
umount ${sd_card_device}?*

# mount dir
mount_dir=mount
rm -rf $mount_dir
mkdir $mount_dir

echo "Ethernet Configuration..."
mount ${sd_card_device}2 $mount_dir
cat ethernet_configuration.txt >> ${mount_dir}/etc/dhcpcd.conf
sync
umount $mount_dir

echo "SSH enable..."
mount ${sd_card_device}1 $mount_dir
touch $mount_dir/ssh
sync
umount $mount_dir

# Clean up
echo "Cleaning up..."
rm -rf $mount_dir
