#! /bin/bash

export DIR=$HOME
export DATA=project/urban_epi/data 
export IND="${DIR}/indicators"
export SH="${DIR}/source/bash" 
export GRASSDB="${DIR}/grassdb" 
export RAS="${DATA}/raster"    
export VEC="${DATA}/vector"   
export SEED="${DIR}/source/seed_data"

for CITY in $SEED/*.shp; do 
echo  source/bash/grass_batch_job.sh $GRASSDB location $CITY ; 
done > source/bash/job_list.txt
