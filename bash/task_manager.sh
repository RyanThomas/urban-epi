#!/bin/bash



# Wite taskfile -- only for cluster
#for city in ${VEC}/city_boundaries/*.shp ; do
#echo build_grass.sh $city >> taskfile.txt; done

# This script takes a single argument in the form of a filepath to a shapefile. 
# To run all the scripts at once, run the commands in the taskfile in sequence.

# Load the script with the command source and specify the grass database location_name and file to import. 
# e.g.: bash  source/bash/grass_batch_job.sh $GRASSDB location $SEED/beijing.shp

# These must be defined before the bash script above will work.
export DIR=$PWD

export DATA="${DIR}/data" 
export IND="${DIR}/indicators"
export SH="${DIR}/source/bash" 
export GRASSDB="${DIR}/grassdb" 
export RAS="${DATA}/raster"    
export VEC="${DATA}/vector"   
export SEED="${DIR}/source/seed_data"

export GISDBASE=$1
echo "gisdbase: $GISDBASE"
export LOCATION="$2$$"
echo "location: $GISDBASE/$LOCATION"
export file=$3
echo "input file: $file"

# create the new grass database
mkdir -p $GISDBASE
cd $GISDBASE

# create the new location and exit
rm -rf $GRASSDB/$LOCATION
grass -e -text -c $file  $LOCATION  $GRASSDB

# set up grass variables
 
echo "GISDBASE: $GRASSDB"                        >  $HOME/.grass7/rc$$
echo "LOCATION_NAME: $LOCATION"                  >> $HOME/.grass7/rc$$
echo "MAPSET: PERMANENT"                         >> $HOME/.grass7/rc$$
echo "GUI: text"                                 >> $HOME/.grass7/rc$$
echo "GRASS_GUI: wxpython"                       >> $HOME/.grass7/rc$$

export GISBASE=/usr/lib/grass70
export PATH=$PATH:$GISBASE/bin:$GISBASE/scripts
export LD_LIBRARY_PATH="$GISBASE/lib"
export GISRC="$HOME/.grass7/rc$$"
export GRASS_ADDON_PATH="$HOME/.grass7/addons"
export GRASS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PYTHONPATH="$GISBASE/etc/python:$PYTHONPATH"
export MANPATH=$MANPATH:$GISBASE/man

export GIS_LOCK=$$

g.gisenv 

# start to import all the data

# Create name variable from file. The variable $1 in the bash portion of this line (not in AWK) 
# represents the filepath for the shapefile you want to run.
export NAME=$(echo `basename $3` | awk -F '.' '{ print $1 }')
# Create bounds variable for g.region
export BOUNDS=$(ogrinfo -al -so $3  | grep "Extent: " | awk '{ gsub ("[(),-]", ""); print ("n="$3+2,"s="$5-2, "e="$4+2, "w="$2-2) }' )  
# Create bounds for gdalwarp +2 degree buffer
export gwarpBOUNDS=$(ogrinfo -al -so $3  | grep "Extent: " |  awk  '{ gsub ("[(),-]", ""); print ($2-2" "$3-2" "$4+2" "$5+2) }' ) 

echo "
#################################
Working on city:    $NAME      
With extent:        $BOUNDS
gdalwarp set to:    $gwarpBOUNDS
#################################
"

# Use the shapefile to create a raster landcover layer with the same extent
# As seen in the help documentation:
#  -tr = destination resolution 
#  -te = destination bounding box, created by string manipulation on ogrinfo
#  -tap = match destination output grid to destination resolution provided in -tr


echo "---Creating location for $NAME"
# call create location script using new tif as input -- for cluster only
# source create_location_grass7.0.2-grace2.sh /dev/shm/ $NAME $RAS/glcf/landuse_cover_${NAME}.tif


export GRASS_BATCH_JOB=$SH/grass_batch_job.sh
grass -text $GRASSDB/$LOCATION/PERMANENT
unset GRASS_BATCH_JOB
