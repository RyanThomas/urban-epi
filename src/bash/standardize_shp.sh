#! bin/bash 

# These scripts were run to generate the shapefiles in the city_boundaries folder.
# There are a number of key concepts illustrated in these lines.
# Encoding
# Dissolving regions
# Basic sql

# First, remove spaces from all the file names.
rename "s/ //g" *

# Beijing: 18 
#beijing.shp
ogr2ogr beijing.shp Beijing.shp -sql "SELECT NAME as nbhd, CODE as nbhd_id FROM Beijing" -t_srs EPSG:4326 -overwrite
mv -f beijing.* ../city_boundaries/

# Sao Paulo: 4877 (ID_2)
ogr2ogr saopaulo.shp BRA_adm3.shp -sql "SELECT NAME_3 as nbhd, ID_3 as nbhd_id FROM BRA_adm3 WHERE ID_2 = 4877" -t_srs EPSG:4326 -overwrite
mv -f saopaulo.* ../city_boundaries/

#Jakarta: 8 (ID_1)
ogr2ogr jakarta.shp IDN_adm2.shp -sql "SELECT NAME_2 as nbhd, ID_2 as nbhd_id FROM IDN_adm2 WHERE ID_1 = 8" -t_srs EPSG:4326 -overwrite
mv -f jakarta.* ../city_boundaries/

#Tokyo: 41 (ID_1)
#Tokyo.shp
ogr2ogr tokyo.shp Tokyo.shp -sql "SELECT Ward as nbhd, N03_008 as nbhd_id, USD as income FROM Tokyo" -t_srs EPSG:4326 -overwrite
mv -f tokyo.* ../city_boundaries/

#Seoul: 16 (ID_1)
ogr2ogr seoul.shp Seoul.shp -sql "SELECT name_eng as nbhd, code as nbhd_id FROM Seoul" -t_srs EPSG:4326 -overwrite
mv -f seoul.* ../city_boundaries/

#Mexico: 9 (ID_1)
ogr2ogr mexico.shp Mexico_City.shp -sql "SELECT NOMLOC as nbhd, CVE_LOC as nbhd_id FROM Mexico_City" -t_srs EPSG:4326 -overwrite
mv -f mexico.* ../city_boundaries/

#HCMC: 26 (ID_1)
ogr2ogr hochiminh.shp VNM_adm2.shp -sql "SELECT NAME_2 as nbhd, ID_2 as nbhd_id FROM VNM_adm2 WHERE ID_1 = 26" -t_srs EPSG:4326 --config SHAPE_ENCODING "" -overwrite
mv -f hochiminh.* ../city_boundaries/

#Manila: 47 (ID_1)
# with dissolve
ogr2ogr manila.shp PHL_adm3.shp -dialect sqlite -sql "SELECT ST_Union(geometry), NAME_2 as nbhd, ID_2 as nbhd_id FROM PHL_adm3 WHERE ID_1 = 47 GROUP BY NAME_2" -t_srs EPSG:4326 -overwrite
mv -f manila.* ../city_boundaries/

#Singapore: 205 (ID_0)
ogr2ogr singapore.shp SLA_SURVEY_DISTRICT.shp -sql "SELECT SURVEY_DIS as nbhd, OBJECTID as nbhd_id FROM SLA_SURVEY_DISTRICT" --config SHAPE_RESTORE_SHX true -t_srs EPSG:4326 -overwrite
mv -f singapore.* ../city_boundaries/

#Delhi: 7 (ID_1)
ogr2ogr delhi.shp wardsdelimited.shp -sql "SELECT ward as nbhd, wardno as nbhd_id FROM wardsdelimited" --config SHAPE_RESTORE_SHX true -t_srs EPSG:4326 -overwrite
mv -f delhi.* ../city_boundaries/

#London: 1 (ID_1) city without surrounding region. Source: Greater London Authority 
# London Boroughs https://data.london.gov.uk/dataset/statistical-gis-boundary-files-london
ogr2ogr london.shp London.shp -sql "SELECT NAME_2 as nbhd, GSS_CODE as nbhd_id FROM London" -t_srs EPSG:4326 -overwrite
mv -f london.* ../city_boundaries/

#Los Angeles: 1 (ID_1) city without surrounding region. Source: LA County Community Planning Areas http://planning.lacity.org/ 
ogr2ogr losangeles.shp LosAngeles.shp -sql "SELECT NAME_2 as nbhd, CPA_NUM as nbhd_id FROM LosAngeles" -t_srs EPSG:4326 -overwrite
mv -f losangeles.* ../city_boundaries/

#New York: 1 (ID_1) city without surrounding region, no district name. 
# Source: NYC Department of City Planning Community District Boundaries https://www1.nyc.gov/site/planning/data-maps/open-data/districts-download-metadata.page
ogr2ogr newyork.shp NewYork.shp -sql "SELECT BoroCD as nbhd_id FROM NewYork" -t_srs EPSG:4326 -overwrite
mv -f newyork.* ../city_boundaries/
