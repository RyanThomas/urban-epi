# This bash script downloads all land cover data fromftp://ftp.glcf.umd.edu/glcf/Global_LNDCVR/UMD_TILES/Version_5.1/2012.01.01
# MCD12 is the code for land cover data from NASA.

DIR=~/projects/urban-epi/GRASS/
GRASSDB=~/grassdb/
TMP=~/projects/urban-epi/GRASS/tmp/

#################################################################################
# Download all the files

#rm -rf $TMP && mkdir $TMP && cd $TMP
#wget -r ftp://ftp.glcf.umd.edu/glcf/Global_LNDCVR/UMD_TILES/Version_5.1/2012.01.01/* 
#cd $DIR

# Gather them into one folder called 'gclf'

#rm -rf $TMP/glcf && mkdir $TMP/glcf
#cp $TMP/ftp.glcf.umd.edu/glcf/Global_LNDCVR/UMD_TILES/Version_5.1/2012.01.01/MCD12Q1_V51_LC1.2012*/*.tif.gz $TMP/glcf

# Unzip them from .gz format.

#cd $TMP/glcf && find . -name '*.gz' -exec gunzip '{}' \;
#cd $DIR

# Uncomment the above lines to download the files again.
#################################################################################################

# Download shapefile with urban areas into new directory.
# For now, I am waiting to include this step, bounding boxes defined manually.
#mkdir ../ne_10m_urban_areas && cd ne_10m_urban_areas
#wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_urban_areas.zip



#####################################################
# Here begins the GRASS database setup.

# First, if you want to start over:
cd $DIR && rm -rf $GRASSDB 

# Creat a vrt from all the tifs
gdalbuildvrt -te -79.5 -1 -77.5 1 -overwrite $TMP/output.vrt $TMP/glcf/*.tif

# Use gdal to make a tif of the study area- in this case, Quito.
gdal_translate -of GTIFF  $TMP/output.vrt  $TMP/quito.tif

# Create a new geoTIFF using a bounding box and the VRT.
# To automate this in the future, create separate tiffs from the VRT in the 
# above line using an input shapefile.
mkdir $GRASSDB && cd $GRASSDB
cp $TMP/quito.tif $GRASSDB/quito.tif


# Write out the projection of the study area
gdalwarp  -t_srs EPSG:4326  -s_srs EPSG:4326  quito.tif quito_proj.tif

# make a new location
rm -rf $GRASSDB/quito 
grass70 -text  -c  -c    quito_proj.tif    quito    $GRASS/epi

# first rename everything into urban/not urban.
# urban land use is categorized as 13. Anything above or below
# 13 is recoded to 0, urban (13) is recoded to 1

#gdal_calc.py -A C:temp\raster.tif --outfile=result.tiff --calc="0*(A<3)" --calc="1*(A>3)"


r.in.gdal input=quito.tif  output=quito

r.recode input=quito output=quito_urban rules=- << EOF
0:0:2
1:12:0
14:*:0
13:13:1
EOF



# clump the contiguous land uses together with the diagonals included.
r.clump -dg quito out=urban_lc

g.gui

determine the 


pkstat -

GHSL JRC

grass
r.grow.distance in grass



Wiki tutorials - grass create location - 

UHI in terms of the impact of density on land surface temperature
Global human settlements layer







