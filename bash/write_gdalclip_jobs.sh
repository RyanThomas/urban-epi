#! /bin/bash

export DIR=$HOME
export DATA=/project/fas/hsu/rmt33/urban_epi/data 
export IND="${DIR}/indicators"
export SH="${DIR}/source/bash" 
export GRASSDB="${DIR}/grassdb" 
export RAS="${DATA}/raster"    
export VEC="${DATA}/vector"   
export SEED="${DIR}/source/seed_data"

for CITY in $SEED/*.shp; do 
echo  source/bash/clip_landuse.sh  $CITY ; 
done > clip_job_tasks.txt

dSQ/dSQ -c 2  --taskfile clip_job_tasks.txt > clip_job_tasks.sh

sbatch clip_job_tasks.sh
