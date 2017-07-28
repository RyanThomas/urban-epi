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

source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/beijing.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/delhi.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/hochiminh.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/jakarta.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/london.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/losangeles.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/manila.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/mexico.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/newyork.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/saopaulo.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/seoul.shp
source/bash/task_manager.sh $GRASSDB location /home/user/projects/urban_epi/source/seed_data/tokyo.shp
