#! /bin/bash

#############################################################################
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
# This file simply calls the grass_patch_statistics file on a folder of shapefiles.


source source/bash/01_export_directory_tree.sh

#---------------------------------------------------------------
# START LOOP
for city in ${VEC}/city_boundaries/*.shp ; do

#------------------------------------------------------
# Create variables from input file
export NAME=$(echo `basename $city` | awk -F '.' '{ print $1 }')
# Create bounds variable for g.region
export BOUNDS=$(ogrinfo -al -so $city  | grep "Extent: " | awk '{ gsub ("[(),]", ""); print ("n="$3+2,"s="$6-2, "e="$5+2, "w="$2-2) }' )
# create bounds for gdalwarp +2 degree buffer
export gwarpBOUNDS=$(ogrinfo -al -so $city  | grep "Extent: " |  awk  '{ gsub ("[(),]", ""); print ($2-2" "$3-2" "$5+2" "$6+2) }' ) 

"""
Use the shapefile to create a raster landcover layer with the same extent options:
 -tr = destination resolution 
 -te = destination bounding box, created by string manipulation on ogrinfo
 -tap = match destination output grid to destination resolution provided in -tr """
echo "---Writing  $RAS/glcf/landuse_cover_${NAME}.tif"
gdalwarp -tr .004666666667 .0046666666667  -te $gwarpBOUNDS -tap -r average -overwrite $RAS/glcf/landuse_cover.vrt  $RAS/glcf/landuse_cover_${NAME}.tif 

echo "---Creating location for $NAME"
echo "---I know $RAS"
source create_location_grass7.0.2-grace2.sh /dev/shm/ rmt33_${NAME} $RAS/glcf/landuse_cover_${NAME}.tif


#------------------------------------------------------
# BEGIN PATCH ANALYSIS
echo "Calculating patch statistics.
#################################
Working on city:    $NAME      
With extent:        $BOUNDS
#################################
"

r.reclass   input=landuse_cover_${NAME}    output=urban   --overwrite rules=- << EOF
13  = 0 urban
*   = NULL
EOF


###########################################################################
# Steps to make the mask
echo "Setting up urban mask."
# 1. Select the big clumps
# clump the contiguous land uses together with the diagonals included.
r.clump   -d  --overwrite   input=urban   output=all_clumps --quiet
# assign clumps with area > 4km^2 to 1, the rest to 0
g.extension -a
$HOME/.grass7/addons/bin/r.area input=all_clumps  output=large_clumps lesser=8 --overwrite --quiet
# TODO: Is 8 right threshold? 
# 2. Make a buffer of 20000 m
r.grow.distance -m  input=large_clumps distance=meters_from_large_clumps  metric=geodesic --quiet --overwrite

r.grow.distance -m  input=all_clumps distance=meters_from_all_clumps  metric=geodesic --quiet --overwrite

r.reclass   input=meters_from_large_clumps   output=buffer --overwrite --quiet rules=- << EOF
0 thru 2000 = 1 urban
*   = NULL
EOF
# 3. Clump the buffered urban land uses.
r.clump -d --overwrite input=buffer   output=extended_urban_area --quiet
# Select the biggest clump as the central urban area.
BIG=$(r.report -n extended_urban_area  units=c sort=asc | awk -F "|" '{ print $2 }' | tail -n 4 | head -n 1)
r.mapcalc  "buffer_mask = if(extended_urban_area==$BIG,1,null())" --overwrite --quiet
echo "buffer_mask made, now calculating neighbors"

# 4. Calculate the urban areas including partial intersections.
# -c uses circular neighbors; add 0 values to 
r.neighbors -c input=buffer_mask  selection=all_clumps    output=buffer_mask  method=stddev size=7 --overwrite --quiet

echo "clipping agglomeration by mask"
r.mask      raster=buffer_mask --quiet
r.mapcalc   "agglomeration = all_clumps" --overwrite --quiet
r.mask -r

# Reclassify all areas with STDEV of 0 or 1 to be part of the urban agglomeration.
r.reclass    input=agglomeration   output=urban_agglomeration --overwrite --quiet rules=- << EOF
* = 1 urban
EOF

g.remove -f type=raster,raster,raster name=extended_urban_area,urban,buffer --quiet

# Make a config file for grass. We determined the text for this configuration through the 
# GUI ahead of time.
mkdir -p $HOME/.grass7/r.li/
echo "SAMPLINGFRAME 0|0|1|1
SAMPLEAREA 0.0|0.0|1.0|1.0" > ~/.grass7/r.li/patch_index

r.li.padcv          input=urban_agglomeration config=patch_index       output=${NAME}.padcv         --overwrite --quiet
r.li.patchdensity   input=urban_agglomeration config=patch_index       output=${NAME}.patchdensity  --overwrite --quiet
r.li.mps            input=urban_agglomeration config=patch_index       output=${NAME}.mps         --overwrite --quiet
r.li.edgedensity    input=urban_agglomeration config=patch_index       output=${NAME}.edgedensity  --overwrite --quiet
r.li.padsd          input=urban_agglomeration config=patch_index       output=${NAME}.padsd      --overwrite  --quiet
r.li.patchnum       input=urban_agglomeration config=patch_index       output=${NAME}.patchnum    --overwrite  --quiet
r.li.padrange       input=urban_agglomeration config=patch_index       output=${NAME}.padrange     --overwrite --quiet
echo "Patch stats complete. Saved to ${NAME}.stat."

#---------------------------------------------------
# 
mkdir -p $DIR/GTiffs/agglomeration
r.out.gdal  input=urban_agglomeration output=GTiffs/agglomeration/${NAME}.tif format=GTiff --overwrite

#----------------------------------------------------------
# AIR STATS
echo "Calculating air statistics."

gdalwarp -tr .010000000 .010000000  -te $gwarpBOUNDS  -tap -r average $RAS/pm25/GlobalGWR_PM25_GL_201401_201412-RH35_NoDust_NoSalt-NoNegs.asc  $RAS/pm25/2014_${NAME}.tif -overwrite

gdalwarp -tr .010000000 .010000000  -te $gwarpBOUNDS  -tap -r average $RAS/pm25/GlobalGWR_PM25_GL_201501_201512-RH35_NoDust_NoSalt-NoNegs.asc  $RAS/pm25/2015_${NAME}.tif -overwrite

#source enter_grass7.0.2-grace2.sh /dev/shm/rmt33_${NAME}/PERMANENT

echo "
#################################
# Working on city:    $NAME #
# with bounds         $BOUNDS #
#################################
"

r.in.gdal input=$RAS/pm25/2014_${NAME}.tif output=2014_${NAME}  --overwrite
r.in.gdal input=$RAS/pm25/2015_${NAME}.tif output=2015_${NAME}  --overwrite

# NOTE: v.external (as used in previous script) does not bring in attributes.
v.in.ogr ${VEC}/city_boundaries/${NAME}.shp  snap=10e-7  --overwrite

echo "
----------------
v.rast.stats
----------------
"

# r.mapcalc  "air_meanpm25 = (air_pm25_2015@PERMANENT + air_pm25_2014@PERMANENT) / 2" --overwrite
v.rast.stats -c map=${NAME} raster=2015_${NAME} column_prefix=a  method=minimum,maximum,average,median,stddev
v.rast.stats -c map=${NAME} raster=2014_${NAME} column_prefix=a  method=minimum,maximum,average,median,stddev
#NOTE: column names cannot be of length > 10.


echo 
r.mapcalc " meters_from_all_clumps_int = round( meters_from_all_clumps@PERMANENT  ) "

mkdir -p ${VEC}/air/
echo "out putting csv"
mkdir -p ${DATA}/stats/air/
echo writing CSV to file
v.out.ogr -c --overwrite input=${NAME} layer=${NAME} output=${DATA}/stats/air/${NAME}.csv format="CSV" --quiet ; 
done

#---------------------------
# END LOOP

echo Cleaning up environment...
rm -rf /dev/shm/rmt33_*

mkdir -p $DATA/stats/
for file in ~/.grass7/r.li/output/*; do
    val=$(cat $file | awk -F "|" '{ print $2 }') 
    echo `basename $file`"."$val | awk   -F "." '{ print $1","$2","$3}';
    done > $DATA/stats/frag_stats.txt

R --vanilla --no-readline   -q <<EOF
require(dplyr)
require(tidyr)
require(magrittr)
frag_stats <- read.table("~/project/urban_epi/data/stats/frag_stats.txt", header = FALSE, sep = ",")
colnames(frag_stats) <- c("stat","city", "value")
frag_stats
frag_stats_wd <- frag_stats %>% spread(stat, value)
postscript("path")  # png("path")
plot(frag_stats_wd)
dev.off()
EOF


