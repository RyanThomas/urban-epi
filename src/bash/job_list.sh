#!/bin/bash

#SBATCH --mem-per-cpu=5G
#SBATCH --array=0-11
#SBATCH --job-name=source/bash/job_list.txt
#SBATCH --cpus-per-task=2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ryan.thomas@yale.edu
#SBATCH --ntasks=1

/gpfs/home/fas/hsu/rmt33/dSQ/dSQBatch.py source/bash/job_list.txt
