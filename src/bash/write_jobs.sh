#! /bin/bash
for CITY in $SEED/*.shp; do 
echo  source/bash/task_manager.sh '$GRASSDB' location $CITY ; 
done > source/bash/job_list.txt
