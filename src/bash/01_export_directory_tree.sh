#! /bin/bash

# This is relative to the directory
# of the git repo, which is in a folder
# called bin. Downloaded data and analyzed
# data goes in sibling directories.

# Absolute path to parent directory
echo
echo "Enter the absolute path to the directory where you want this project to live. (e.g. $PWD)"

read DIR

if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not your current, returning to prompt." >> /dev/stderr
  read -p "Press enter to continue."
  echo "Please enter the absolute path to the parent directory. Hint: This is the directory where you ran `git clone [git repo url] source`.
"
    read DIR

fi

# Top level directories. These don't exist yet.
export DATA="${DIR}/data" # $1
export IND="${DIR}/indicators" # $2
mkdir -p $DATA # make new directories
mkdir -p $IND

# Location of bash scripts
export SH="${DIR}/source/bash" # $3
mkdir -p $SH

# Grass DB directories
export GRASSDB="${DIR}/grassdb" # $4
mkdir -p $GRASSDB

# Raw data directories
export RAS="${DIR}/data/raster"    # $5 all and only raster data goes here
export VEC="${DIR}/data/vector"    # $6 all and only vector data goes here.
export TMP="${DIR}/data/tmp"      # $7 used to download and unzip files.
mkdir -p $RAS
mkdir -p $VEC 
mkdir -p $TMP

export CITIES="${VEC}/city_shapes"
mkdir -p "$CITIES"

export SEED="${DIR}/source/seed_data"

echo "Finished creating directories!
"

