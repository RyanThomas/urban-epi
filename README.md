Urban Environmental Assessment Tool
==================================

This is a research tool for global urban environmental assessment. The program takes as an input a directory (file folder) of shapefiles with income and population data. Based on these shapefiles, the program will produce estimates for air quality, transportation, urban form, and green space. To replicate this analysis for a city you have in mind, begin by cloning the repo with `git clone http://github.com/ryanthomas/urban_epi.git` and overwrite the contents of the `city_boundary` folder with the shapefile for your city. Then follow the instructions below.

## Requirements
All the tools used in this analysis are open source, including the data, which are freely available on the internet.
- Unix environment (e.g. Any Linux or MacOS. If you're going to use a virtual machine, I suggest [OSGeoLive in a virtual machine](https://live.osgeo.org/en/quickstart/virtualization_quickstart.html)).
- GDAL/OGR
- GRASS 7.0 or GRASS 7.2 linked to the commandline call `grass`
  - Extensions are loaded by the program: r.li, v.in.osm 
- AWK
- NodeJS (for the `osmtogeojson` commandline tool)
- Anaconda with Python 2 or 3 
- Access to the data used in this application - see the Setup section below.

## Setup
Importantly, the repo is intended to be cloned into a directory parent directory and renamed "source". In other words, the name of the directory once it is cloned should be "source", and it should be in a parent directory.
#### Set up directory tree and get code
- From your home (`~/`) directory, run `mkdir urban_epi/ && cd urban_epi`. This is to make the 'parent directory' called 'urban_epi'. Feel free to call this something else. In my environment, it is called urban_epi.</br>
- Run `git clone http://github.com/ryanthomas/urban-epi.git source` to clone and rename the diectory.
- Run `source source/bash/01_export_directory_tree.sh`

`echo '#!/bin/bash <br>

export DIR=$PWD # home or parent directory for the code base of the project<br>
export DATA="/project/fas/hsu/rmt33/urban_epi/data" <br>
export IND="${DIR}/indicators"<br>
export SH="${DIR}/source/bash" <br>
export GRASSDB="${DIR}/grassdb" <br>
export RAS="${DATA}/raster"    <br>
export VEC="${DATA}/vector"' > source/bash/grass_variables.sh`<br>

#### Get data
The data are available on the Yale High Performance Computing Cluster in the `/project/fas/hsu/rmt/urban_epi/data/` directory. Once you have access to the cluster, you can run `scp [from] [to]`. <br>
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

If you are running a download script from the cluster, run the command line script `bash source/install_node_on_cluster.sh`

## Running the script
### From your laptop/VM
From your <i>parent directory</i>, run `source/bash/grass_batch_script.sh grassdb/urban [path/to/georeferenced_file]`

### From the cluster - in parellel
#### Install dead Simple Queue from the YCRC github page. 
From your <i>parent directory</i>:
- run `git clone https://github.com/ycrc/dSQ.git`

#### Run the batch script
- run `source/bash/write_jobs.sh` to write a tasks.txt.
- run `dSQ/dSQ --taskfile tasks.txt > tasks.sh`
- run `sbatch tasks.sh`

To come!: To run all these scripts at once, run `source/bash/run_scripts_in_parallel.sh`.

