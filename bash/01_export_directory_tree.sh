#! /bin/bash

# This is relative to the directory
# of the git repo, which is in a folder
# called bin. Downloaded data and analyzed
# data goes in sibling directories.

export DIR=$(echo $PWD)

export DATA=/project/fas/hsu/rmt33/urban_epi/data
export IND=${DIR}/indicators
export SH=${DIR}/source/bash/
export GRASSDB=~/scratch60/grassdb/
export RAS=${DATA}/raster    # all and only raster data goes here
export VEC=${DATA}/vector    # all and only vector data goes here.
export TMP=${DATA}/tmp/      # used to download and unzip files.
echo -------------------------
echo Exporting variables done.
echo -------------------------
