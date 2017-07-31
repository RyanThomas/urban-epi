
import os, sys

import osmnx as ox, matplotlib.pyplot as plt
from descartes import PolygonPatch
from shapely.geometry import Polygon, MultiPolygon
import json

from places import *

data_path = os.path.dirname('../../data/vector/city_networks/')

ox.config(log_console=True, use_cache=True, data_folder=data_path)

def ensure_dir(file_path):
    directory = os.path.dirname(file_path)
    if not os.path.exists(directory):
        os.makedirs(directory)
        

for place in places:
    
    name = (place.replace(",","").replace(" ","")) # make better place_names
    print('working on: ', name)

    #make a geodataframe of the street network (outline) from openstreetmap place names
    # use retain_all if you want to keep all disconnected subgraphs (e.g. when your places aren't adjacent)
    G = ox.graph_from_place(place, network_type='drive', retain_all=True)
    G = ox.project_graph(G)
    
    #make a geodataframe of the shape (outline) from openstreetmap place names
    gdf = ox.gdf_from_place(place)
    gdf = ox.project_gdf(gdf)
    ox.save_graph_shapefile(G, filename=name)
    
    
    print(name, ' has crs:' ) 
    gdf.to_crs({'init': 'epsg:3395'})
    # Confirm big step of projection change
    
    # calculate basic stats for the shape
    # TODO adjust this to calculate stats based on neighborhoods
    stats = ox.basic_stats(G, area=gdf['geometry'].area[0])
    print('area', gdf['area'][0] / 10**6, 'sqkm')

    # save to file:
    def ensure_dir(file_path):
        directory = os.path.dirname(file_path)
        if not os.path.exists(directory):
            os.makedirs(directory)
    
    # define path and save to file
    path = '../../data/vector/city_networks/' + name + '/'
    ensure_dir(path)
    with open(path + 'stats.json', 'wb') as f:
        json.dump(stats, f)
        
    print('graph stats for ', name, 'success!')
