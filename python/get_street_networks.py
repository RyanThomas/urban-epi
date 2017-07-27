#! /bin/bash/env python

import osmnx as ox, matplotlib.pyplot as plt
from descartes import PolygonPatch
from shapely.geometry import Polygon, MultiPolygon
import geopandas as gpd
import json
import os, sys, glob

ox.config(log_console=True, use_cache=True, data_folder='data/vector/city_networks/')

scriptpath = os.path.dirname(__file__)
cities = glob.glob("data/vector/city_boundaries/*.shp")


#indir = "data/vector/city_boundaries/"
for city in cities:
    name = os.path.basename(city).split('.')[0]
    
    place = gpd.read_file(city)
    place_simple = place.unary_union # disolving boundaries based on attributes

    # Use retain_all if you want to keep all disconnected subgraphs (e.g. when your places aren't adjacent)
    G = ox.graph_from_polygon(place_simple, network_type='drive', retain_all=True)
    G_projected = ox.project_graph(G)

    # save the shapefile to disk
    #name = os.path.basename("beijing.shp")).split(".")[0]  # make better place_names
    ox.save_graph_shapefile(G_projected, filename=name)

    area = ox.project_gdf(place).unary_union.area
    stats = ox.basic_stats(G, area=area)
    # save to file:
    def ensure_dir(file_path):
        directory = os.path.dirname(file_path)
        if not os.path.exists(directory):
            os.makedirs(directory)

    path = os.path.join('data/vector/city_networks/', name)
    ensure_dir(path)
    with open(path + '_stats.json', 'wb') as f:
        json.dump(stats, f)
        










