#!/bin/bash

DEVICE=
VARIANT=
TARGET=SD/bpi-m2m

if [ ! -d ${TARGET} ]; then
	echo -e "\033[31mNo download files exits, check build and pack. \033[0m"
	exit 1
fi

echo "--------------------------------------------------------------------------------"
echo "  1. LCD5 Panel"
echo "  2. LCD7 Panel"
echo "--------------------------------------------------------------------------------"

read -p "Please choose a type to install: " type
echo

if [ -z "${type}" ]; then
        echo -e "\033[31mNo install type choose \033[0m"
	exit 1
fi

case ${type} in
	1) VARIANT="LCD5";;
	2) VARIANT="LCD7";;
esac

read -p "Please type the SD device(/dev/sdX): " DEVICE
echo

if [ ! -b ${DEVICE} ]; then
	echo -e "\033[31mNo SD device exists \033[0m"
	exit 1
fi

read -p  "${VARIANT} type will be intalled to ${DEVICE}, [Y/n] " input
echo

case ${input} in
	[yY]) echo "Yes";;
	[nN]) echo "No, stop install";;
	*)
	  echo -e "\033[31mInvalid input \033[0m"
	  exit 1
	  ;;
esac

echo

BOOTLOADER=${TARGET}/100MB/BPI-M2M-${VARIANT}-8k.img.gz

## download bootloader
if [ ! -f ${BOOTLOADER} ]; then
	echo -e "\033[31mbootloader download file not exist, please check you build. \033[0m"
	exit 1
fi

echo "sudo gunzip -c ${BOOTLOADER} | dd of=${DEVICE} bs=1024 seek=8"
sudo gunzip -c ${BOOTLOADER} | sudo dd of=${DEVICE} bs=1024 seek=8
sync
echo
echo "bootloader download finished"
echo

## boot and root
cd ${TARGET}
if command -v bpi-update > /dev/null 2>&1; then
	sudo bpi-update -d ${DEVICE}
else
	cd -
	echo -e "\033[31mbpi-update command not exists, please install it before run this script, more reference to https://github.com/BPI-SINOVOIP/bpi-tools \033[0m"
	exit 1
fi
cd -

## end

