#!/bin/bash -e
## prepare SDK environment
source ~/env.sh

## TODO: this is my "poor people's udev" (aaargh - sic transit gloria mundi!)
sudo chmod 666 /dev/bus/usb/$(lsusb | grep "Altera" | awk '{ print $2 "/" $4 }' | tr -d ':')

## start quartus
/opt/altera/quartus/bin/quartus
