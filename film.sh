#!/bin/bash
# Written by Kevin Cole <kjcole@ubuntu.com> 2012.12.27
# This software is released under the the Creative Commons 
# Attribution-NonCommercial-ShareAlike 3.0 licence (CC BY-NC-SA 3.0)
# http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
#
# Let's make an animated movie with POVray!
#

povray +I${1}.pov ${1}.ini
png2yuv -I p -f 25 -j ${1}%03d.png -b 1 > ${1}.yuv
ffmpeg2theora --optimize --videoquality 10 --videobitrate 16778 \
              -o ${1}.ogv ${1}.yuv 
rm ${1}0*.png ${1}1*.png ${1}.yuv
