#!/bin/bash

# This script takes a single argument in the form of a filepath to a shapefile. 
# To run all the scripts at once, run the commands in the taskfile in sequence.

# Load the script with the command source and specify the grass database location_name and file to import. 
# e.g.: bash  source/bash/grass_batch_job.sh $GRASSDB location $SEED/beijing.shp

# These must be defined before the bash script above will work.
export DIR=$HOME

export DATA=/project/fas/hsu/rmt33/urban_epi/data/
export IND="${DIR}/indicators"
export SH="${DIR}/source/bash" 
export GRASSDB="${DIR}/grassdb" 
export RAS="${DATA}/raster"    
export VEC="${DATA}/vector"   
export SEED="${DIR}/source/seed_data"

export GISDBASE=$1
export LOCATION="$2$$"
# Create name variable from file. The variable $1 in the bash portion of this line (not in AWK) 
# represents the filepath for the shapefile you want to run.
export NAME=$(echo `basename $3` | awk -F '.' '{ print $1 }')
# Create bounds variable for g.region
export BOUNDS=$(ogrinfo -al -so $3  | grep "Extent: " | awk '{ gsub ("[(),-]", ""); print ("n="$3+2,"s="$5-2, "e="$4+2, "w="$2-2) }' )  
# Create bounds for gdalwarp +2 degree buffer
export gwarpBOUNDS=$(ogrinfo -al -so $3  | grep "Extent: " |  awk  '{ gsub ("[(),-]", ""); print ($2-2" "$3-2" "$4+2" "$5+2) }' ) 

echo "LOCATION_NAME: $LOCATION"          > $HOME/.grass7/rc_$$
echo "GISDBASE: $GISDBASE"              >> $HOME/.grass7/rc_$$
echo "MAPSET: PERMANENT"                >> $HOME/.grass7/rc_$$
echo "GRASS_GUI: text"                  >> $HOME/.grass7/rc_$$
 
# path to GRASS settings file
export GISRC=$HOME/.grass7/rc_$$
export GRASS_PYTHON=python
export GRASS_MESSAGE_FORMAT=plain
export GRASS_PAGER=cat
export GRASS_WISH=wish
export GRASS_ADDON_BASE=$HOME/.grass7/addons
export GRASS_VERSION=7.0.2
export GISBASE=/usr/local/cluster/hpc/Apps/GRASS/7.0.2/grass-7.0.2
export GRASS_PROJSHARE=/usr/local/cluster/hpc/Libs/PROJ/4.8.0/share/proj/
export PROJ_DIR=/usr/local/cluster/hpc/Libs/PROJ/4.8.0
 
export PATH="$GISBASE/bin:$GISBASE/scripts:$PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$GISBASE/lib"
export GRASS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
#export PYTHONPATH="$GISBASE/etc/python:$PYTHONPATH"
export MANPATH=$MANPATH:$GISBASE/man
export GIS_LOCK=$$
export GRASS_OVERWRITE=1

export GRASS_BATCH_JOB=$SH/grass_batch_job.sh
grass70 -text -c  $RAS/glcf/landuse_cover_${NAME}.tif urban $GRASSDB 
unset GRASS_BATCH_JOB
