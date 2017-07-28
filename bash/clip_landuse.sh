#!/bin/bash

#SBATCH --partition=general
#SBATCH --job-name=clip_landuse
#SBATCH --ntasks=12 
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8000 
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ryan.thomas@yale.edu

for CITY in $SEED/*.shp; do
NAME=$(echo `basename "$CITY"` | awk -F '.' '{ print $1 }')
# Create bounds variable for g.region
# Create bounds for gdalwarp +2 degree buffer
export gwarpBOUNDS=$(ogrinfo -al -so $CITY  | grep "Extent: " | \
    awk  '{ gsub ("[(),-]", ""); print ($2-2" "$3-2" "$4+2" "$5+2) }' ) 

echo "Writing  $RAS/glcf/landuse_cover_${NAME}.tif"
# LAND USE: transform vrt to tif with correct projection and bounds of each city
gdalwarp -te $gwarpBOUNDS -r average -multi -wo NUM_THREADS=2 -overwrite \
    $RAS/glcf/landuse_cover.vrt \
    $RAS/glcf/landuse_cover_${NAME}.tif 
# AIR QUALITY 2014
#TODO: Make these air files into VRT.
gdalwarp  -te $gwarpBOUNDS -r average -multi -wo NUM_THREADS=2 -overwrite \
    $RAS/pm25/GlobalGWR_PM25_GL_201401_201412-RH35_NoDust_NoSalt-NoNegs.asc \
    $RAS/air_pm25_2014_${NAME}.tif 
# AIR QUALITY 2015
gdalwarp  -te $gwarpBOUNDS -r average -multi -wo NUM_THREADS=2 -overwrite \
    $RAS/pm25/GlobalGWR_PM25_GL_201501_201512-RH35_NoDust_NoSalt-NoNegs.asc \
    $RAS/air_pm25_2015_${NAME}.tif ; done
    
