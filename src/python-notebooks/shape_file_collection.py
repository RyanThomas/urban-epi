import osmnx as ox, matplotlib.pyplot as plt
from descartes import PolygonPatch
from shapely.geometry import Polygon, MultiPolygon
ox.config(log_console=True, use_cache=True)

#Beijing, Jakarta, London, Los Angeles, Manila, Mexico, New Delhi, New York,Sao Paulo, Seoul, Singapore, Tokyo, Lagos,
#Nairobi, Bangalore, Ho Chi Minh

place_names = ['Ho Chi Minh City, Vietnam',
               #'Beijing, China', 
               #'Jakarta, Indonesia',
               'London, UK',
               'Los Angeles, California, USA',
               'Manila, Philippines',
               #'Mexico City, Mexico',
               'New Delhi, India',
               'Sao Paulo, Brazil',
               'New York, New York, USA',
               'Seoul',
               'Singapore',
               #'Tokyo, Japan',
               #'Nairobi, Kenya',
               #'Bangalore, India'
              ]
              
# In this for-loop, we save all the shapefiles for the valid cities.
for city in place_names:  
    city_admin_20kmbuff = ox.gdf_from_place(city, gdf_name = 'global_cities', buffer_dist = 20000)
    fig, ax = ox.plot_shape(city_admin_20kmbuff)
    ox.save_gdf_shapefile(city_admin_20kmbuff, filename = city)
    
# In this for-loop, we save all the street networks for the valid cities.
for city in place_names:
    grid = ox.graph_from_place(city, network_type = 'drive', retain_all = True)
    grid_projected = ox.project_graph(grid)
    ox.save_graph_shapefile(grid_projected, filename = city + '_grid')
    ox.plot_graph(grid_projected)
