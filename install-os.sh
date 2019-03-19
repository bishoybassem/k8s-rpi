#!/bin/bash -e

if [ $EUID -ne 0 ]; then
    echo "Please run the script as root!"
    exit 1
fi

os_image_path=$1
if [ ! -f "$os_image_path" ]; then
    echo "Please enter a valid path to the os image file!"
    exit 1
fi

pi_name=$2
if [ -z "$pi_name" ]; then
    echo "Please enter a hostname for the pi!"
    exit 1
fi

sd_card=$(lsblk -l -o NAME,TYPE | grep 'disk$' | grep '^mmcblk' | cut -f 1 -d ' ')
if [ -z "$sd_card" ]; then
    echo "Could not find the SD card's device name!"
    exit 1
fi

sd_card_path="/dev/$sd_card"
echo "The SD card's block device is $sd_card_path"

read -p "Please enter 'y' to proceed or 'n' to abort: " choice
if [ "$choice" != "y" ]; then
    echo "Aborted!"
    exit 0
fi

echo "Unmounting card partitions ..."
umount -f ${sd_card_path}?* || true

echo "Writing image to $sd_card_path ..."
dd if=${os_image_path} of=${sd_card_path} bs=4M status=progress conv=fsync

echo "Mounting back the partitions ..."
partprobe -s ${sd_card_path}
boot_path=/media/sd_boot
rootfs_path=/media/sd_rootfs
mkdir -p ${boot_path}
mkdir -p ${rootfs_path}
mount -t vfat "${sd_card_path}p1" ${boot_path}
mount -t ext4 "${sd_card_path}p2" ${rootfs_path}

echo "Configuring hostname ..."
echo ${pi_name} > ${rootfs_path}/etc/hostname

if [ -f wpa_supplicant.conf ]; then
    echo "Placing wpa_supplicant.conf ..."
    cp wpa_supplicant.conf ${boot_path}
fi

sed -i 's/slaac private/slaac hardware/g' ${rootfs_path}/etc/dhcpcd.conf

echo "Enabling ssh access ..."
touch ${boot_path}/ssh
if [ -f authorized_keys ]; then
    echo "Authorized public keys would be used, disabling ssh password access ..."
    mkdir -p ${rootfs_path}/home/pi/.ssh
    cp authorized_keys ${rootfs_path}/home/pi/.ssh
    chown -R 1000:1000 ${rootfs_path}/home/pi/.ssh
    sed -i -e 's/UsePAM.*/UsePAM no/' -e 's/#PasswordAuth.*/PasswordAuthentication no/' ${rootfs_path}/etc/ssh/sshd_config
fi

echo "Unmounting card partitions ..."
umount -f ${sd_card_path}?* || true

echo "Done!"