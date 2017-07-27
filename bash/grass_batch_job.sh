#!/bin/bash

#r.in.gdal for all global rasters to PERMANENT mapset. 

r.in.gdal     input=$RAS/glcf/landuse_cover_beijing.tif   output=landuse --overwrite
r.in.gdal     input=$RAS/air_pm25_2014_${NAME}.tif output=air_pm25_2014 --overwrite
r.in.gdal     input=$RAS/air_pm25_2015_${NAME}.tif output=air_pm25_2015 --overwrite 

g.region      raster=landuse


#------------------------------------------------------
# BEGIN PATCH ANALYSIS
echo "
Calculating patch statistics for
city:               $NAME      
with extent:        $BOUNDS
"

# change landuse classifications so there are two values, 0 (for urban areas) and NULL
r.reclass   input=landuse    output=urban   --overwrite rules=- << EOF
13  = 0 urban
*   = NULL
EOF

# clump the contiguous land uses together with the diagonals included.
r.clump   -d  --overwrite   input=urban   output=all_clumps --quiet

###########################################################################
# Steps to make the mask
echo "Setting up urban mask."
# 1. Select the big clumps
# assign clumps with area > 4km^2 to 1, the rest to 0
#g.extension extension=r.area
r.area input=all_clumps  output=large_clumps   --overwrite   lesser=16 --quiet   

# TODO: Is 8 right threshold? 
# 2. Make a buffer of 2000 m
# create raster of distances from large clumps
r.grow.distance -m  input=large_clumps distance=meters_from_large_clumps  metric=geodesic --quiet --overwrite
# reclassify to 1 (urban) and NULL
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
# -c uses circular neighbors
r.neighbors -c input=buffer_mask  selection=all_clumps    output=buffer_mask  method=stddev size=7 --overwrite --quiet

echo "clipping agglomeration by mask"
# define mask
r.mask      raster=buffer_mask --quiet
# re-write file while mask is in place
r.mapcalc   "agglomeration = all_clumps" --overwrite --quiet
# remove mask
r.mask -r

# Reclassify all areas with STDEV of 0 or 1 to be part of the urban agglomeration.
r.reclass    input=agglomeration   output=urban_agglomeration --overwrite --quiet rules=- << EOF
* = 1 urban
EOF

# clean up environment from temp layers
g.remove -f type=raster,raster,raster name=extended_urban_area,urban,buffer --quiet

# Make a config file for grass. We determined the text for this configuration through the 
# GUI ahead of time.
mkdir -p ~/.grass7/r.li/
echo "SAMPLINGFRAME 0|0|1|1
SAMPLEAREA 0.0|0.0|1.0|1.0" > ~/.grass7/r.li/patch_index

r.li.padcv          input=urban_agglomeration config=patch_index       output=${NAME}_padcv         --overwrite --quiet
r.li.patchdensity   input=urban_agglomeration config=patch_index       output=${NAME}_patchdensity  --overwrite --quiet
r.li.mps            input=urban_agglomeration config=patch_index       output=${NAME}_mps         --overwrite --quiet
r.li.edgedensity    input=urban_agglomeration config=patch_index       output=${NAME}_edgedensity  --overwrite --quiet
r.li.padsd          input=urban_agglomeration config=patch_index       output=${NAME}_padsd      --overwrite  --quiet
r.li.patchnum       input=urban_agglomeration config=patch_index       output=${NAME}_patchnum    --overwrite  --quiet
r.li.padrange       input=urban_agglomeration config=patch_index       output=${NAME}_padrange     --overwrite --quiet
echo "Patch stats complete. Saved to ${NAME}_[stat name]."

# create new directory to store tifs
mkdir -p ${DIR}/GTiffs/agglomeration
r.out.gdal  input=urban_agglomeration output=${DIR}/GTiffs/agglomeration/$NAME format=GTiff --overwrite
   
mkdir -p $DATA/stats/
    for file in ~/.grass7/r.li/output/*; do
     val=$(cat $file | awk -F "|" '{ print $2 }') 
     echo `basename $file`"."$val | awk   -F "." '{ print $1","$2","$3}'
    done > $DATA/stats/frag_stats.txt

#----------------------------------------------
# Patch stats complete


#######################################
#
# Air Stats
#
#######################################
echo Patch stats complete, calculating air statistics.

# NOTE: v.external (as used in previous script) does not bring in attributes.
# TODO: get this to work.
v.in.ogr ${SEED}/${NAME}.shp  snap=10e-7  --overwrite

echo "
----------------
v.rast.stats
----------------
"
# r.mapcalc  "air_meanpm25 = (air_pm25_2015@PERMANENT + air_pm25_2014@PERMANENT) / 2" --overwrite
v.rast.stats -c map=${NAME} raster=air_pm25_2015 column_prefix=a  method=minimum,maximum,average,median,stddev
v.rast.stats -c map=${NAME} raster=air_pm25_2014 column_prefix=a  method=minimum,maximum,average,median,stddev
#NOTE: column names cannot be of length > 10.

r.mapcalc " meters_from_all_clumps_int = round( meters_from_all_clumps@${NAME}  ) "

mkdir -p ${VEC}/air/
echo "outputting csv"

# TODO look up -c flag, which is giving a warning now.
v.out.ogr -c input=${NAME} layer=${NAME} output=${DATA}stats/air/${NAME}.csv format="CSV"  --overwrite --quiet

echo "
-------------------------------------------
Air stats done, working on transport for city:    $NAME    
-------------------------------------------
"

########################################################
# Transportation statistics.
########################################################

echo "Calculating transport statistics."

# TODO:should these cities be in a different folder? 
transport_file=${VEC}/networks/${NAME}/edges/edges.shp 

mkdir -p ${VEC}/networks/${NAME}/edges_proj/ &&   rm -rf ${VEC}/city_networks/${NAME}/edges_proj/*
mkdir -p ${VEC}/networks/${NAME}/nodes_proj/ &&   rm -rf ${VEC}/city_networks/${NAME}/nodes_proj/*

ogr2ogr  -t_srs EPSG:4326 ${VEC}/networks/${NAME}/edges_proj/edges.shp ${VEC}/networks/${NAME}/edges/edges.shp 
ogr2ogr  -t_srs EPSG:4326 ${VEC}/networks/${NAME}/nodes_proj/nodes.shp ${VEC}/networks/${NAME}/nodes/nodes.shp

export int=${VEC}/networks/${NAME}/nodes_proj/nodes.shp
export net=${VEC}/networks/${NAME}/edges_proj/edges.shp 

# Road network stats here.

# Public transportation stats here.


#g.mapset mapset=$NAME --quiet
g.region vector=$NAME

echo "Reading in data."
v.in.ogr -t input=$net output=streets        type=point --overwrite
v.in.ogr -t input=$int output=intersections  type=line  --overwrite

echo "calculate stats"
v.vect.stats  points=intersections         areas=${NAME}              count_column=int
mkdir -p $DATA/stats/transportation/
v.report      map=${NAME}       option=area         separator=","       unit=kilometers > $DATA/stats/transportation/${NAME}.txt
v.kernel      input=intersections output=int_density     radius=0.001           --overwrite
v.vect.stats -c  map=${NAME}                raster=int_density         column_prefix=id  method=average


#-----------------------------------------
# Green space stats  
echo "Calculating greenspace statistics."

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
v.db.addcolumn nbhd_parks col="area DOUBLE PRECISION"  --overwrite 
v.to.db map=nbhd_parks@${NAME} layer=1 qlayer=1 option=area units=meters columns=area  --overwrite 
v.centroids input=nbhd_parks output=park_cent option=add   --overwrite 
v.vect.stats points=nbhd_parks areas=${NAME} type=centroid method=sum count_column="parks" points_column=area stats_column="park_area"   --overwrite 

#mkdir -p $DATA/stats/
#for file in ${VEC}/air**.csv; do
    
#echo `basename $file`"."$val | awk   -F "." '{ print $1","$2","$3}'
#    done > $DATA/stats/air_stats.txt

# Create plot for fragstats
#    R --vanilla --no-readline   -q  <<'EOF'
# INDIR = Sys.getenv(c('INDIR'))

R --vanilla <<EOF
require(dplyr)
require(tidyr)
frag_stats <- read.table("~/projects/urban_epi/data/stats/frag_stats.txt", header = FALSE, sep = ",")
colnames(frag_stats) <- c("stat","city", "value")
frag_stats
frag_stats_wd <- frag_stats %>% spread(stat, value)
postscript("path")  # png("path")
plot(frag_stats_wd)
dev.off()
EOF

#g.extension extension=v.in.osm

#Land Coverhttp://wiki.openstreetmap.org/wiki/OSM_file_formats

########################cd ..
##############################################
#r.in.gdal for all global rasters to PERMANENT mapset. 
#r.in.gdal     input=raw/gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals_2015.tif   output=pop_density_2015
#r.in.gdal     input=raw/Hansen_GFC2015_gain_00N_080W.tif   output=tree_gain
#r.in.gdal     input=raw/Hansen_GFC2015_loss_00N_080W.tif   output=quito_tree_losss
#r.external     input=$RAS/glcf/landuse_cover.vrt     output=landuse --overwrite
#r.external     input=$RAS/pm25/GlobalGWR_PM25_GL_201401_201412-RH35_NoDust_NoSalt-NoNegs.asc output=air_pm25_2014 --overwrite
#r.external     input=$RAS/pm25/GlobalGWR_PM25_GL_201501_201512-RH35_NoDust_NoSalt-NoNegs.asc output=air_pm25_2015 --overwrite 
cd $DIR

