#!/bin/bash
# Determine the distances from every grid node to the nearest coastline
# provided by the coastline segments in gshhs_c.txt.
# We evaluate the grid with distances using sphdistance.
# This is pretty slow (5 minutes on my laptop).  The result
# is a PNG file (spheredist.png) @ 300 dpi.

verbose=-V	# Comment this out for a quiet run
# Set output PostScript plot name
ps=spheredist.ps
# Get Voronoi polygons
gmt sphtriangulate gshhs_c.txt -Qv -D > tt.pol
# Compute distances in km on a 2x2 arc minute global grid
gmt sphdistance -Rg -I2m -Qtt.pol -Gtt.nc -Lk $verbose
# Get hot colortable
gmt makecpt -Chot -T0/3500 > t.cpt
# Make a basic image plot and overlay contours, Voronoi polygons and coastlines
gmt grdimage tt.nc -JG-150/30/7i -P -K -Ct.cpt -X0.75i -Y2i > $ps
gmt pscoast -R -J -O -W1p -Dh -Gsteelblue -A0/1/1 -B30g30 -K >> $ps
gmt psscale -Ct.cpt -O -Dx3.5i/7.5i+w6i+h+jBC -Baf >> $ps
# Make png
gmt psconvert $ps -TG -A -P -E300 -Z
# Clean up
rm -f gmt.conf tt.pol t.cpt
echo "spheredist.sh: Finished, see spheredist.png and grid tt.nc"
