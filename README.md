Urban Environmental Assessment Tool
==================================

This is a research tool for global urban environmental assessment. The program takes as an input a directory (file folder) of shapefiles with income and population data. Based on these shapefiles, the program will produce estimates for air quality, transportation, urban form, and green space. To replicate this analysis for a city you have in mind, begin by cloning the repo with `git clone http://github.com/ryanthomas/urban-epi.git` and overwrite the contents of the `city_boundary` folder with the shapefile for your city. Then follow the instructions below.

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
- `git clone http://github.com/ryanthomas/urban-epi.git` to clone and rename the diectory.
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
The data are available on the Yale High Performance Computing Cluster in the `/project/fas/hsu/rmt/urban_epi/data/` directory. Once you have access to the cluster, you can run `scp [from] [to]`. <br>
For example: `scp netid@grace-next.hpc.yale.edu:/project/fas/hsu/rmt/urban_epi/data/ location/on/your/computer`. 

#### Anaconda Installation
I recommend installing conda, because it makes cloning the Python environment very easy. [See the page here for instructions.](https://www.continuum.io/downloads)

Once you do this, you have to restart your terminal or type `. ~/.bashrc` to get access to the `conda` command.

### Create a new python environment using conda.
`conda env create -f source/environment.yml`
### Activate the new environment
`source activate uepi`


## Details
### `source/bash/00_setup.sh -dir`</br>
This will prompt you to enter the <i>absolute</i> path to your parent directory (chosen above). Use the following steps to get the absolute path to your parent directory. You will need to do this outside the script's dialogue (i.e. before typing the above script). You can also exit once you start without breaking anything.</br> 
- Enter the directory from a bash terminal. If you haven't moved, do nothing - you're already there. </br> 
- Type `echo $PWD` in your bash terminal, and</br>
- Copy the output.

