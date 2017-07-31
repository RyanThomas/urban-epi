#! bin/bash
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

LOCATION_NAME=urban
NAME=$(echo `basename $1` | awk -F '[._]' '{ print $1 }')
BOUNDS=$(ogrinfo -al  $1  | grep "Extent: " | awk -F "[ (,)]" '{ print ("n="$5+2,"s="$11-2, "e="$9+2, "w="$3-2) }' )


echo "
#################################
Working on city:    $NAME 
with bounds         $BOUNDS
#################################
"

# set mapping region
g.mapset -c ${NAME}
g.region vector=${NAME}

# NOTE: v.external (as used in previous script) does not bring in attributes.
# TODO: Fix projection issue
v.in.ogr ${VEC}/greenspaces/${NAME}.shp  snap=10e-7  output=parks --overwrite
#v.in.ogr ${VEC}/greenspaces/${NAME}_parks.shp  snap=10e-7 output=london_grn --overwrite
v.overlay ainput=parks binput=${NAME} operator="and" output=nbhd_parks snap=.000001 --overwrite 
v.db.addcolumn nbhd_parks col="area DOUBLE PRECISION"
v.to.db map=nbhd_parks@${NAME} layer=1 qlayer=1 option=area units=meters columns=area
v.centroids input=nbhd_parks output=park_cent option=add
v.vect.stats points=nbhd_parks areas=${NAME} type=centroid method=sum count_column="parks" points_column=area stats_column="park_area"



#mkdir -p ${DATA}stats/greenspace
#v.out.ogr -c input=${NAME}@${NAME} layer=${NAME} output=${DATA}stats/greenspace/${NAME}.csv format="CSV"  --overwrite --quiet
#mkdir -p ${DATA}/vector/out/
#v.out.ogr -c input=${NAME}@${NAME} layer=${NAME} output=${DATA}/vector/out/${NAME}.shp   --overwrite --quiet
