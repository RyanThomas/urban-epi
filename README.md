Urban Environmental Assessment Tool
==================================

This is a research tool for global urban environmental assessment. The program takes as an input a directory (file folder) of shapefiles with income and population data. Based on these shapefiles, the program will produce estimates for air quality, transportation, urban form, and green space. To replicate this analysis for a city you have in mind, begin by cloning the repo with `git clone http://github.com/ryanthomas/urban_epi.git` and overwrite the contents of the `city_boundary` folder with the shapefile for your city. Then follow the instructions below.

## Requirements
All the tools used in this analysis are open source, including the data, which are freely available on the internet.
- Unix environment (e.g.[OSGeoLive in a virtual machine](https://live.osgeo.org/en/quickstart/virtualization_quickstart.html))
- GDAL/OGR
- GRASS 7.0 or GRASS 7.2 linked to the commandline call `grass`
  - Extensions are loaded by the program: r.li, v.in.osm 
- AWK
- NodeJS (for the `osmtogeojson` commandline tool)
- Anaconda with Python 2 or 3 
- Access to the data used in this application - see the Setup section below. Right now, the easiest way to do this is through the Yale High Performance Computing Cluster, where the data are available in the `/project/fas/hsu/rmt/urban_epi/data/` directory. 

## Setup
Importantly, the repo is intended to be cloned into a directory parent directory and renamed "source". In other words, the name of the directory once it is cloned should be "source", and it should be in a parent directory.
#### Set up directory tree and get code
- `mkdir urban_epi/ && cd urban_epi ` This is to make the parent directory called 'urban_epi'. Feel free to call this something else. In my environment, it is called urban_epi.</br>
- `git clone http://github.com/ryanthomas/urban-epi.git source` to clone and rename the diectory.
- `source source/01_export_directory_tree.sh`
#### Get data
Once you have access to the cluster, you can run `scp [from] [to]`. <br>
For example: `scp netid@grace-next.hpc.yale.edu:/project/fas/hsu/rmt/urban_epi/data/ location/on/your/computer`. 

### Anaconda Installation
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

### `source/bash/00_setup.sh -data` </br>
This takes exceedingly long, since there are several global rasters involed. This is the main reason for splitting the process into multiple parts. Future iterations of this project may involve targeted downloading of only necessary files. 

### `source/bash/00_setup.sh -build` </br>
Reads in data to PERMANENT mapset.

### `source/bash/00_setup.sh -air` </br>
Calculates statistics for air quality.

### `source/bash/00_setup.sh -form` </br>
Calculates statistics for urban form.

### `source/bash/00_setup.sh -trans` </br>
Calculates statistics for transportation.

### `source/bash/00_setup.sh -green` </br>
Coming soon...
