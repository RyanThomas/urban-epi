r.grow.distance -m --quiet input=urban distance=test_distance value=meters_from_urban metric=geodesic
g.gui
d.rast map=urban@PERMANENT
d.mon wx0
d.rast wx0 map=urban@PERMANENT
d.rast  map=urban@PERMANENT
g.list raster
exit
