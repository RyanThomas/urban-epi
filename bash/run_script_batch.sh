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
    echo  source/bash/task_manager.sh ${DIR}/grassdb/ urban  $CITY  ; 
done > urban_batch_tasks.txt

dSQ/dSQ -c 2  --taskfile urban_batch_tasks.txt > urban_batch_tasks.sh

sbatch urban_batch_tasks.sh
