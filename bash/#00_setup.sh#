#!/bin/bash

###########################################################################
#
# AUTHOR(S):    Ryan Thomas, Yale University
#               
# PURPOSE:      This script runs commands to download data and set up a 
#		GRASS70 database used to calculate the Urban Environmental
#		Assessent Tool.
# 
#############################################################################

# Because pwd is relative, this must be run from a specific directory.

source ~/source/bash/01_export_directory_tree.sh
echo Skipping to $1.

if [ "$1" = "-dir" ]; then

mkdir -p $DATA
mkdir -p $IND
mkdir -p $SH
mkdir -p $GRASSDB
mkdir -p $RAS 
mkdir -p $VEC 
mkdir -p $TMP 
echo "Directory tree created."


echo ---------------------------------------------------------
echo "Finished creating directories!
If you wish to download the data run: ./00_setup.sh -data
"
echo ---------------------------------------------------------
exit 0


#######################################################################
#
# DOWNLOAD 
#
echo "Would you like to continue to DOWNLOAD the data?"
read dl
#######################################################################
elif  [ "$1" = "-data" ] || [ "$dl" = "y" ] ; then

echo ------------------------------------------------------------------------------
echo "Running download script. This will take a while. Why don't you grab a coffee in the Agora?"
echo ------------------------------------------------------------------------------
source/bash/02_download_data.sh
echo
echo "Download compete!"

#######################################################################
#
# BUILD 
echo "Would you like to continue to BUILD the database?"
read bd
#######################################################################
elif  [ "$1" = "-build" ] || [ "$bd" = "y" ]  ; then


echo ---------------------------
echo "building grass"
echo -------------------------

# mkdir -p ${VEC}/city_boundaries/ && cp ${DIR}/source/seed_data/* ${VEC}/city_boundaries/

# make vrt to create global location
bash create_location.sh
#grass70 -text -c   urban scratch60/grassdb/
g.extension extension=v.in.osm

#r.in.gdal for all global rasters to PERMANENT mapset. 

r.external     input=$RAS/glcf/landuse_cover.vrt     output=landuse --overwrite
r.external     input=$RAS/pm25/GlobalGWR_PM25_GL_201401_201412-RH35_NoDust_NoSalt-NoNegs.asc output=air_pm25_2014 --overwrite
r.external     input=$RAS/pm25/GlobalGWR_PM25_GL_201501_201512-RH35_NoDust_NoSalt-NoNegs.asc output=air_pm25_2015 --overwrite 




#######################################################################
#
# FORM
echo "Would you like to continue to calculate FORM stats?"
read fm
#######################################################################

elif  [ "$1" == "-form" ] || [ "$fm" = "y" ] ; then
    
echo ---------------------------
echo "analyzing urban form"
echo -------------------------
# Reading in patch analysis script from bin.
rm -rf ~/.grass7/r.li/output/*
export GRASS_BATCH_JOB="$SH/04_urban_form_analysis.sh"

grass -text -c $GRASSDB/urban/PERMANENT/
unset GRASS_BATCH_JOB


#######################################################################
#
# AIR 
#
echo "Would you like to continue to calculate AIR stats?"
read ar

#######################################################################
elif  [ "$1" = "-air" ] || [ "$ar" = "y" ] ; then
   
echo ---------------------------
echo "analyzing air quality"
echo -------------------------
# Reading in patch analysis script from bin.
export GRASS_BATCH_JOB="$SH/05_air_pm25.sh"
GISDBASE=$GRASSDB/urban
grass -text -c $GRASSDB/urban/PERMANENT
unset GRASS_BATCH_JOB



#######################################################################
#
# AIR 
#
echo "Would you like to continue to calculate TRANSPORT stats?"
read tr

#######################################################################
elif  [ "$1" = "-trans" ] || [ "$tr" = "y" ] ; then
   
echo ---------------------------
echo "analyzing transportation"
echo -------------------------
# Reading in patch analysis script from bin.
rm -rf $GRASSDB/transportation
export GRASS_BATCH_JOB="$SH/06_transport.sh"
GISDBASE=$GRASSDB/transportation
grass -text  $GRASSDB/urban/PERMANENT
unset GRASS_BATCH_JOB



#######################################################################
#
# AIR 
#
echo "Would you like to continue to calculate GREENSPACE stats?"
read gr

#######################################################################
elif  [ "$1" = "-green" ] || [ "$gr" = "y" ] ; then
    
echo ---------------------------
echo "analyzing greenspace"
echo -------------------------
# Reading in patch analysis script from bin.
export GRASS_BATCH_JOB="$SH/07_greenspace.sh"

GISDBASE=$GRASSDB/urban
for CITY in ${VEC}/city_boundaries/*.shp ; 
do
    export CITY
    grass -text  $GRASSDB/urban/PERMANENT; 
    done
unset GRASS_BATCH_JOB
unset name


#######################################################################
elif  [ "$1" = "-stats" ] || [ "$gr" = "y" ] ; then
    
echo ---------------------------
echo "exporting stats to: ${DATA}stats/final/[city].csv"
echo -------------------------
# Reading in patch analysis script from bin.
export GRASS_BATCH_JOB="${SH}/export_stats.sh"

GISDBASE=$GRASSDB/urban
for CITY in ${VEC}/city_boundaries/*.shp ; 
do
export CITY
grass -text  $GRASSDB/urban/PERMANENT; 
done

unset GRASS_BATCH_JOB
unset name

fi

