Urban Environmental Assessment Tool
==================================

This is a research tool for global urban environmental assessment.

## Requirements
All the tools used in this analysis are open source, including the data, which are freely available on the internet.
- Bash environment
- GDAL/OGR
- GRASS 7.0 or GRASS 7.2
- AWK or GAWK
- Internet connection (downloads take a long time [>1 hour] on slow internet)

## Setup
Importantly, the repo is intended to be cloned into a parent directory and renamed "source". The name of the directory once it is cloned should be "source".

`mkdir urban_epi` This is to make the parent directory called 'urban_epi'. Feel free to call this something else. In my environment, it is called urban_epi.</br>
`git clone http://github.com/ryanthomas/urban-epi.git source` to clone and rename the diectory.

The setup script takes one of three arguements: 
- `-dir` : To set up the directory structure,
- `-data` : To download the data, and
- `-grass` : To set up the grass database.
It is necessary that these be run one at a time in this order. </br>
// Future developments may allow them to be run together with an `-all` flag.</br>

### `source/bash/setup.sh -dir`</br>
This will prompt you to enter the <i>absolute</i> path to your parent directory (chosen above). Use the following steps to get the absolute path to your parent directory. You will need to do this outside the script's dialogue (i.e. before typing the above script). You can also exit once you start without breaking anything.</br> 
- Enter the directory from a bash terminal. If you haven't moved, do nothing - you're already there. </br> 
- Type `echo $PWD` in your bash terminal, and</br>
- Copy the output.

### `source/bash/setup.sh -data` </br>
This takes exceedingly long, since there are several global rasters involed. This is the main reason for splitting the process into multiple parts. Future iterations of this project may involve targeted downloading of only necessary files. 

### `source/bash/setup.sh -grass` </br>
This sets up the grassdatabase with mapsets for every city stored in ./data/vector/city_shapes directory.

