#! /bin/bash

# This bash script downloads all data for the Urban EPI from the source, as well as setting up the proper directory structure.
source source/bash/01_export_directory_tree.sh
export DATA=/project/fas/hsu/rmt33/urban_epi/data   
export RAS=${DATA}/raster    # all and only raster data goes here
export VEC=${DATA}/vector    # all and only vector data goes here.
export SEED=~/source/seed_data/


rm -rf $TMP && mkdir -p $TMP  # Make a TMP folder to store all downloads

# Land cover data from: ftp://ftp.glcf.umd.edu/glcf/Global_LNDCVR/UMD_TILES/Version_5.1/2012.01.01
# MCD12 is the code for land cover data from NASA.z

cd $TMP && wget -r ftp://ftp.glcf.umd.edu/glcf/Global_LNDCVR/UMD_TILES/Version_5.1/2012.01.01/*   # Download files into TMP (working dir)
mkdir $RAS/glcf/ && mv $TMP/*/*/*/*/*/*/*/*.tif.gz  $RAS/glcf  # MOVE files from TMP to RAW/glcf 
rm -rf $RAS/*/*/*/*/*/*/*/* 
cd $RAS/glcf && find . -name '*.gz' -exec gunzip '{}' \;       # Unzip them from .gz format.

# Use GDAL command to make virtual raster (.vrt) from all the glcf tifs
gdalbuildvrt -overwrite -a_srs "EPSG:4326"  $RAS/glcf/landuse_cover.vrt    $RAS/glcf/*.tif  

# Protected Planet dot Net files used for biodiversity.
# NOTE: We are not useing this protected planet shapefile for this. 
# Could be used in future.
#cd $TMP && wget http://wcmc.io/wdpa_current_release 

# Get city shape files using python osmnx script.
# NOTE: The cities are hard-coded right now. 
# TODO: Adapt this script so it takes a directory of shapefiles.
echo  ---------------------------------------------
echo  Use OSMnx to get street network
echo ----------------------------------------------
python source/python/get_city_streets.py



## Population density from University of Columbia's SEDAC, CEISN.
#cd $TMP
#wget http://sedac.ciesin.columbia.edu/downloads/data/gpw-v4/gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals/gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-2015.zip

#unzip -f gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-2015.zip  -d    pop_density 

echo  ---------------------------------------------
echo  Use OverpassAPI to get parks
echo ----------------------------------------------
rm -rf ${VEC}/greenspaces/* # remove contents of greenspaces directory
mkdir -p ${VEC}/greenspaces/ # make directory (-p flag means "if not exists")

for file in ${VEC}/city_boundaries/*.shp; do # loop through shapefiles in city_boundaries
export NAME=$(echo `basename $file` | awk -F '[._]' '{ print $1 }') # make the simple name based on filenames
export bbox=$(ogrinfo -al $file  | grep "Extent: " | awk -F "[ (,)]" '{ print ($5-.1","$3-.1","$11+.1","$9+.1) }' ) # write the bounding boxes
 
echo -------------------------------------------------------
echo getting osm greenspaces for $NAME
echo with bbox: $bbox
echo -------------------------------------------------------
# Read greenspaces matching the following key:value pairs.
# helpful documentation: http://blog-en.openalfa.com/how-to-query-openstreetmap-using-the-overpass-api
# NOTE: bounding box is in following order (south,west,north,east)
# TODO: investigate whether we should add nodes to the API query.
# First, we write the query to a file.
echo "[out:xml][timeout:900][maxsize:1073741824];(( 
    rel["leisure"="park"](${bbox});
    way["leisure"="park"](${bbox});
    rel["leisure"="garden"](${bbox});
    way["leisure"="garden"](${bbox});
    rel["leisure"="pitch"](${bbox});
    way["leisure"="pitch"](${bbox});
    rel["leisure"="golf_course"](${bbox});
    way["leisure"="golf_course"](${bbox});
    rel["leisure"="playground"](${bbox});
    way["leisure"="playground"](${bbox});
    rel["leisure"="nature_reserve"](${bbox});
    way["leisure"="nature_reserve"](${bbox});
    rel["amenity"="grave_yard"](${bbox});
    way["amenity"="grave_yard"](${bbox});
    rel["landuse"="cemetery"](${bbox});
    way["landuse"="cemetery"](${bbox});
    rel["landuse"="forest"](${bbox});
    way["landuse"="forest"](${bbox});
    rel["landuse"="meadow"](${bbox});
    way["landuse"="meadow"](${bbox});
    rel["natural"="scrub"](${bbox});
    way["natural"="scrub"](${bbox});
    rel["natural"="wood"](${bbox});
    way["natural"="wood"](${bbox});
    rel["natural"="heath"](${bbox});
    way["natural"="heath"](${bbox});
    rel["boundary"="national_park"](${bbox});
    way["boundary"="national_park"](${bbox}););
  >;); out body; >; out;" >${VEC}/greenspaces/${NAME}_query.osm # save query to file for debugging/ troubleshooting/ record-keeping
  # then use the --post-file option to call in the query, like so:
wget -O  ${VEC}/greenspaces/${NAME}.osm --post-file=${VEC}/greenspaces/${NAME}_query.osm "http://overpass-api.de/api/interpreter";


# OSM files are not simple to coerce into a usable format for GRASS or otherwise.
# This NodeJS library (osmtogeojson) is clutch for this and may be #useful elsewhere.
# If you do not have nodejs installed, this StackOverflow post helps you.
# http://stackoverflow.com/questions/30281057/node-forever-usr-bin-env-node-no-such-file-or-directory
osmtogeojson -m -ndjson ${VEC}/greenspaces/${NAME}.osm > ${VEC}/greenspaces/${NAME}.geojson # Magically converts osm files to GeoJSON.

# convert the vector file old.shp to a raster file new.tif using a pixel size of XRES/YRES
gdal_rasterize -tr .00001 .00001 -burn 255 -ot Byte -co COMPRESS=DEFLATE ${VEC}/greenspaces/${NAME}.geojson ${VEC}/greenspaces/${NAME}.tif
# convert the raster file new.tif to a vector file new.shp, using the same raster as a -mask speeds up the processing
gdal_polygonize.py -f 'ESRI Shapefile' -mask ${VEC}/greenspaces/${NAME}.tif ${VEC}/greenspaces/${NAME}.tif ${VEC}/greenspaces/${NAME}.shp
# removes the DN attribute created by gdal_polygonize.py
#ogrinfo ${NAME}.shp -sql "ALTER TABLE ${NAME} DROP COLUMN DN"
rm -f ${VEC}/${NAME}.tif
# It *may* be possible to completely flatten the osm file without this with PostGIS similar to the below line - not yet functional.
#ogr2ogr -f GeoJSON ${VEC}/greenspaces/${NAME}_dissolved.geojson ${VEC}/greenspaces/${NAME}.geojson -dialect sqlite -sql "SELECT ST_Union(geometry) FROM OGRGeoJSON"
done


echo  ---------------------------------------------
echo  Use wget to download vonDonkelaar air data
echo ----------------------------------------------
mkdir -p ${RAS}/pm25
wget -P ${RAS}/pm25 http://fizz.phys.dal.ca/~atmos/datasets/EST2016/GlobalGWR_PM25_GL_201401_201412-RH35_NoDust_NoSalt-NoNegs.asc.zip 
wget -P ${RAS}/pm25 http://fizz.phys.dal.ca/~atmos/datasets/EST2016/GlobalGWR_PM25_GL_201501_201512-RH35_NoDust_NoSalt-NoNegs.asc.zip
  
