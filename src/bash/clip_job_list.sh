#!/bin/bash

#SBATCH --partition=general
#SBATCH --job-name=uepi
#SBATCH --ntasks=12 --nodes=12
#SBATCH --mem-per-cpu=8000 
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=email

export DIR=$HOME
export DATA=project/urban_epi/data

export IND="${DIR}/indicators"
export SH="${DIR}/source/bash" 
export GRASSDB="${DIR}/grassdb"
export SEED="${DIR}/source/seed_data"
 
export RAS="${DATA}/raster"    
export VEC="${DATA}/vector"   

echo source/bash/clip_landuse.sh $SEED/beijing.shp
echo source/bash/clip_landuse.sh $SEED/delhi.shp
echo source/bash/clip_landuse.sh $SEED/hochiminh.shp
echo source/bash/clip_landuse.sh $SEED/jakarta.shp
echo source/bash/clip_landuse.sh $SEED/london.shp
echo source/bash/clip_landuse.sh $SEED/losangeles.shp
echo source/bash/clip_landuse.sh $SEED/manila.shp
echo source/bash/clip_landuse.sh $SEED/mexico.shp
echo source/bash/clip_landuse.sh $SEED/newyork.shp
echo source/bash/clip_landuse.sh $SEED/saopaulo.shp
echo source/bash/clip_landuse.sh $SEED/seoul.shp
echo source/bash/clip_landuse.sh $SEED/tokyo.shp
