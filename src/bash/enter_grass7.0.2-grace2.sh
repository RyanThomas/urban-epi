#!/bin/bash

# If you are using qsub in a HPC you should run GRASS scripts in a non-interactively from outside of a GRASS session by setting the GRASS_BATCH_JOB environment variables.
# When GRASS is started with this environment variables set it will automatically run the contents of the script given in the variable, then close the GRASS session when complete. 
# source enter_grass.sh  $HOME/ost4sem/grassdb/europe/PERMANENT

GISDBASE=$(dirname $(dirname  $1))
LOCATION_NAME=$(basename $(dirname  $1))
MAPSET=$(basename  $1) 

echo Enter in GRASS using GISDBASE =  $GISDBASE , LOCATION = $LOCATION_NAME , MAPSET =  $MAPSET  

echo "LOCATION_NAME: $LOCATION_NAME"                               > $HOME/.grass7/grass$$
echo "GISDBASE: $GISDBASE"                                        >> $HOME/.grass7/grass$$
echo "MAPSET: $MAPSET"                                            >> $HOME/.grass7/grass$$
echo "GRASS_GUI: text"                                            >> $HOME/.grass7/grass$$

# path to GRASS settings file

export GISRC=$HOME/.grass7/grass$$
export GRASS_PYTHON=python
export GRASS_MESSAGE_FORMAT=plain
export GRASS_PAGER=cat
export GRASS_WISH=wish
export GRASS_ADDON_BASE=$HOME/.grass7/addons
export GRASS_VERSION=7.0.2
export GISBASE=/gpfs/apps/hpc.rhel7/Apps/GRASS/7.0.2/grass-7.0.2
export GRASS_PROJSHARE=/gpfs/apps/hpc.rhel7/Libs/PROJ/4.9.3/share/proj
export PROJ_DIR=/gpfs/apps/hpc.rhel7/Libs/PROJ/4.9.3

export PATH="$GISBASE/bin:$GISBASE/scripts:$PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$GISBASE/lib"
export GRASS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PYTHONPATH="$GISBASE/etc/python:$PYTHONPATH"
export MANPATH=$MANPATH:$GISBASE/man
export GIS_LOCK=$$
export GRASS_OVERWRITE=1

echo "########################"
echo Welcome to GRASS 
echo "########################"

g.gisenv  

echo "########################"
echo Start to use GRASS comands
echo "########################"
