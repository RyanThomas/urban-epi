# create the new grass database

GRASSDB=/home/user/projects/urban_epi/grassdb
#INPUT=/home/user/ost4sem/exercise/basic_adv_gdalogr/fagus_sylvatica

rm -rf $GRASSDB
mkdir $GRASSDB

#cp -n $INPUT/2020_TSSP_IM-ENS-A2-SP20_43023435.tif  $GRASSDB

cd $GRASSDB


# create the new location and exit
rm -rf $GRASSDB/location
grass70 -e -text -c -c $SEED/beijing.shp   location  $GRASSDB

# set up grass variables
 
echo "GISDBASE: $GRASSDB"   >  $HOME/.grass7/rc$$
echo "LOCATION_NAME: location"                >> $HOME/.grass7/rc$$
echo "MAPSET: PERMANENT"                         >> $HOME/.grass7/rc$$
echo "GUI: text"                                 >> $HOME/.grass7/rc$$
echo "GRASS_GUI: wxpython"                       >> $HOME/.grass7/rc$$

export GISBASE=/usr/lib/grass70
export PATH=$PATH:$GISBASE/bin:$GISBASE/scripts
export LD_LIBRARY_PATH="$GISBASE/lib"
export GISRC=$HOME/.grass7/rc$$
export GRASS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PYTHONPATH="$GISBASE/etc/python:$PYTHONPATH"
export MANPATH=$MANPATH:$GISBASE/man

export GIS_LOCK=$$

g.gisenv 

# start to import all the data 

for file in $SEED/*.shp  ; do 
    filename=$( basename $file .shp)
    v.in.ogr input=$file output=$filename  --o   -o snap=1e-10
done 

g.list rast 
