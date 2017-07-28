#!/bin/bash

#SBATCH --partition=general
#SBATCH --job-name=uepi
#SBATCH --ntasks=12 --nodes=12
#SBATCH --mem-per-cpu=8000 
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=email

export DIR=$PWD

export DATA="${DIR}/data" 
export IND="${DIR}/indicators"
export SH="${DIR}/source/bash" 
export GRASSDB="${DIR}/grassdb" 
export RAS="${DATA}/raster"    
export VEC="${DATA}/vector"   
export SEED="${DIR}/source/seed_data"

source/bash/task_manager.sh $GRASSDB location $SEED/beijing.shp
source/bash/task_manager.sh $GRASSDB location $SEED/delhi.shp
source/bash/task_manager.sh $GRASSDB location $SEED/hochiminh.shp
source/bash/task_manager.sh $GRASSDB location $SEED/jakarta.shp
source/bash/task_manager.sh $GRASSDB location $SEED/london.shp
source/bash/task_manager.sh $GRASSDB location $SEED/losangeles.shp
source/bash/task_manager.sh $GRASSDB location $SEED/manila.shp
source/bash/task_manager.sh $GRASSDB location $SEED/mexico.shp
source/bash/task_manager.sh $GRASSDB location $SEED/newyork.shp
source/bash/task_manager.sh $GRASSDB location $SEED/saopaulo.shp
source/bash/task_manager.sh $GRASSDB location $SEED/seoul.shp
source/bash/task_manager.sh $GRASSDB location $SEED/tokyo.shp
