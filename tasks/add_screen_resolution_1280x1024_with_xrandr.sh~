#!/usr/bin/bash
#Author dev@Borodin-Atamanov.ru
#License: MIT
cvt 1280 1024 60
modeline='Modeline "1280x1024_60.00"  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync';
modeline_name='"1280x1024_60.00"';
modeline="${modeline_name}  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync";
echo $modeline;
#xrandr  --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr  --newmode "${modeline}"
#xrandr --addmode VGA1 1920x1080_60.00
xrandr --addmode HDMI-1 "${modeline_name}"
#xrandr --output VGA1 --mode  1920x1080_60.00
xrandr --output HDMI-1 --mode  "${modeline_name}"
xrandr

