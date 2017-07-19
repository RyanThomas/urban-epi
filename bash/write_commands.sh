#!/bin/bash

source source/bash/01_export_directory_tree.sh

for city in ${VEC}/city_boundaries/*.shp ; do
echo build_grass.sh $city >> ${SH}/batch_commands.txt; done
