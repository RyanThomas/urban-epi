Urban Environmental Assessment Tool
==================================

This is a research tool for global urban environmental assessment. The program takes as an input a directory (file folder) of shapefiles with income and population data. Based on these shapefiles, the program will produce estimates for air quality, transportation, urban form, and green space. To replicate this analysis for a city you have in mind, begin by cloning the repo with `git clone http://github.com/ryanthomas/urban_epi.git` and overwrite the contents of the `city_boundary` folder with the shapefile for your city. Then follow the instructions below.

## Requirements
All the tools used in this analysis are open source, including the data, which are freely available on the internet.
- Unix environment
- GDAL/OGR
- GRASS 7.0 or GRASS 7.2 linked to the commandline call `grass`
+ Extensions are loaded by the program: r.li, v.in.osm 
- AWK or GAWK
- NodeJS; osmtogeojson
- python packages
+ osmnx
+ matplotlib
+ descartes
+ shapely.geometry
+ geopandas
+ rtree
+ json
+ os, sys, glob
- Internet connection (downloads take a long time [>1 hour] on slow internet)


## Setup
Importantly, the repo is intended to be cloned into a parent directory and renamed "source". The name of the directory once it is cloned should be "source".

`mkdir urban_epi` This is to make the parent directory called 'urban_epi'. Feel free to call this something else. In my environment, it is called urban_epi.</br>
`git clone http://github.com/ryanthomas/urban-epi.git source` to clone and rename the diectory.

The setup script takes one of three arguements: 
| Command | Description |
| --- | --- |
| `source/bash/00_setup.sh -dir` | To set up the directory structure |
| `source/bash/00_setup.sh -data` | To download the data |
| `source/bash/00_setup.sh -build` | To set up the grass database |
| `source/bash/00_setup.sh -form` | To calculate the urban form statistics |
| `source/bash/00_setup.sh -air` | To calculat the air indicators |
| `source/bash/00_setup.sh -trans` | To calculat the transportation indicators |

It is necessary that these be run one at a time in this order. </br>
// Future developments may allow them to be run together with an `-all` flag.</br>

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