#! /bin/bash
###########################################################################
#
# AUTHOR(S):    Ryan Thomas, Yale University
#               
# PURPOSE:      This script allows a number of grass70 functions to be 
#               performed on multiple files in different mapsets.
#               variables:
#               -bounds    bounding box
#               -name      file name
#               -location  GRASS location
# 
#############################################################################

echo "GISDBASE: ~/scratch60/grassdb/"        >  $HOME/.grass7/rc$$
echo "LOCATION_NAME: urban"                 >> $HOME/.grass7/rc$$
echo "MAPSET: PERMANENT"                    >> $HOME/.grass7/rc$$
echo "GUI: text"                            >> $HOME/.grass7/rc$$
echo "GRASS_GUI: wxpython"                  >> $HOME/.grass7/rc$$


export GISBASE=$HOME/bin/grass
export PATH=$PATH:$GISBASE/bin:$GISBASE/scripts
export LD_LIBRARY_PATH="$GISBASE/lib"
export GISRC=$HOME/.grass7/rc$$
export GRASS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PYTHONPATH="$GISBASE/etc/python:$PYTHONPATH"
export MANPATH=$MANPATH:$GISBASE/man
