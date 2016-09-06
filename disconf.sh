#!/bin/bash

# Configure resolution of external monitor.
# This is useful because OS like Ubuntu and Debian can't handle this
# correctly, expecially on laptops.For example, on my 1920*1080
# PHILIPS monitor, the default resolution is only 1024*768.
# Usage: ./disconf 1 // if your external monitor is called VGA1

#cvt 1920 1080

xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode VGA$1 "1920x1080_60.00"
xrandr --output VGA$1 --mode "1920x1080_60.00"
