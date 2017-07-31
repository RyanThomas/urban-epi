Urban Environmental Assessment Tool
==================================

This is a research tool for global urban environmental assessment. The program takes as an input a directory (file folder) of shapefiles with income and population data. Based on these shapefiles, the program will produce estimates for air quality, transportation, urban form, and green space. To replicate this analysis for a city you have in mind, begin by cloning the repo with `git clone http://github.com/ryanthomas/urban_epi.git` and overwrite the contents of the `city_boundary` folder with the shapefile for your city. Then follow the instructions below.

## Requirements
All the tools used in this analysis are open source, including the data, which are freely available on the internet.
- Unix environment (e.g. the Yale HPC, any Linux or MacOS. If you're going to use a virtual machine on your laptop, I suggest [OSGeoLive in a virtual machine](https://live.osgeo.org/en/quickstart/virtualization_quickstart.html)). Allocate at least 4GB RAM and 50GB storage.
- GDAL/OGR
- GRASS 7.0 or GRASS 7.2 (linked to the commandline call `grass`)
  - GRASS extensions installed prior to running the program: r.li, v.in.osm.
- AWK
- NodeJS (After downloading OSM data, we use the `osmtogeojson` commandline tool.)
- Anaconda with Python 2 or 3
- Access to the data used in this application - see the <b>Setup</b> section below.

## Setup
This repo contains only the code for an application that builds a database.
#### Set up directory tree and get code
- Run `git clone http://github.com/ryanthomas/urban-epi.git` to clone and rename the diectory.
- Run `echo '#!/bin/bash <br>
export DIR=$PWD # home or parent directory for the code base of the project<br>
export DATA="/project/fas/hsu/rmt33/urban-epi/data" <br>
export IND="${DIR}/indicators"<br>
export SH="${DIR}/src/bash" <br>
export GRASSDB="${DIR}/grassdb" <br>
export RAS="${DATA}/raster"    <br>
export VEC="${DATA}/vector"' > src/bash/grass_variables.sh<br>
source src/bash/grass_variables.sh


#### Get data
The data are available on the Yale High Performance Computing Cluster in the `/project/fas/hsu/rmt/urban-epi/data/` directory. Once you have access to the cluster, you can run `scp [from] [to]`. <br>
For example: `scp netid@grace-next.hpc.yale.edu:/project/fas/hsu/rmt/urban_epi/data/ location/on/your/computer`.
Run this from your Mac command line when you are NOT connected to the cluster. Windows users should look up the appropriate command on Yale's HPC help site.

#### Anaconda Installation
I recommend installing conda, because it makes cloning the Python environment very easy. [See the page here for instructions.](https://www.continuum.io/downloads)

Once you do this, you have to restart your terminal or type `. ~/.bashrc` to get access to the `conda` command.

##### Create a new python environment using conda.
`conda env create -f source/environment.yml`
##### Activate the new environment
`source activate uepi`

#### Install Node and NPM
This is only relevant if you are going to be downloading data from OSM using their API. The OSM extracts are saved in a file format that we convert to GeoJSON via a command line utility available through Node - osmtogeojson. Node installs take a little time to run, but are pretty straightforward on a Mac. 

If you are running a download script from the cluster, run the command line script `bash src/install_node_on_cluster.sh`

## Running the script
### From your laptop/VM
From your <i>parent directory</i>, run `src/bash/grass_batch_script.sh grassdb/urban [path/to/georeferenced_file]`

### From the cluster - in parellel
#### Install dead Simple Queue from the YCRC github page. 
From your <i>parent directory</i>, run `git clone https://github.com/ycrc/dSQ.git`

#### Run the batch script
- run `src/bash/write_jobs.sh` to write a tasks.txt.
- run `dSQ/dSQ --taskfile tasks.txt > tasks.sh`
- run `sbatch tasks.sh`

To come!: To run all these scripts at once, run `src/bash/run_scripts_in_parallel.sh`.

