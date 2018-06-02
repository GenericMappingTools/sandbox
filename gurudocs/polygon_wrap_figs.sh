#!/bin/bash
# This script makes the figures used in PolygonWrapping.tex
# Paul Wessel, May 30, 2018
# It uses the the files test_polygon_lonlat.txt and test_polygon_xy_J[MH].txt
# test_polar_lonlat.txt and test_polar_xy_JN.txt
# test_polygon_xy_J[MH].txt were produced by running 
# gmt psxy -R0/360/0/90 -JH180/6i test_polygon_lonlat.txt -Gred -A > /dev/null
# gmt psxy -R180/180/15/65 -JM0/6i test_polygon_lonlat.txt -Gred -A > /dev/null
# gmt psxy -R-180/180/-90/-55 -JN-70/6i test_polar_lonlat.txt -Gred -A > /dev/null
# and doctoring the code to write out test_polygon_xy_J[HM].txt as
# the projected x,y in inches but AFTER we have determined all
# the E-W jumps and added extra points at both the exit and reentry
# point on the other side.  I also wrote out the map width at each
# y value (since it changes depending on the projection) as well as
# the cumulative sum of the pen code (0 = draw, 1 = move).  Since we
# start with a move (1) then those values are 1 1 1 1 2 2 2 2 3 3 3...
# I then use those codes to add or subtract the map width to create
# a left and a right copy of the polygon.  These are only identical
# translated copies of each other when the periodic map boundary is
# vertical.

# MAP PROJECTION WITH STRAIGHT SIDES

# Plot of polygon with view at Greenwhich

gmt psxy -R-180/180/15/65 -JM0/6i -P -Gred -W1p -Bafg180 -BWSne test_polygon_lonlat.txt --MAP_FRAME_TYPE=plain > pwrap_JM_1.ps

# Raw plot of output of wrapped polygon

gmt psxy -R-0.5/6.75/0/1.5 test_polygon_xy_JM.txt -Jx1i -P -Wfaint -K > pwrap_JM_2.ps
gmt psxy -R test_polygon_xy_JM.txt -J -O -K -Sc1p -Gred >> pwrap_JM_2.ps
gmt psxy -R0/360/15/65 -JM180/6i -O -T -X0.5i -B0 --MAP_FRAME_PEN=faint --MAP_FRAME_TYPE=plain >> pwrap_JM_2.ps

# Create the left-wrapped and right-wrapped polygons
awk '{printf "%.16g\t%s\n", $1+(($3-1)%2)*$4, $2}' test_polygon_xy_JM.txt > R.txt
awk '{printf "%.16g\t%s\n", $1-(($3)%2)*$4, $2}'   test_polygon_xy_JM.txt > L.txt

# Plot the two polygons
gmt psxy -R-0.5/6.75/0/1.5 L.txt R.txt -Jx1i -P -Wfaint -K > pwrap_JM_3.ps
gmt psxy -R0/360/15/65 -JM180/6i -O -T -X0.5i -B0 --MAP_FRAME_PEN=faint --MAP_FRAME_TYPE=plain >> pwrap_JM_3.ps

# Finally plot the two polygons and overlay the correct GMT-produced filled polygon
gmt psxy -R-0.5/6.75/0/1.5 L.txt R.txt -Jx1i -P -Wfaint -K > pwrap_JM_4.ps
gmt psxy -R0/360/15/65 -JM180/6i -O -Gred -X0.5i test_polygon_lonlat.txt -B0 --MAP_FRAME_PEN=faint --MAP_FRAME_TYPE=plain >> pwrap_JM_4.ps

gmt psconvert pwrap_JM_?.ps -Tf -P -A -Z

# MAP PROJECTION WITH CURVED SIDES

# Plot of polygon with view at Greenwhich

gmt psxy -R0/360/0/90 -JH0/6i -P -Gred -W1p -Bafg180 test_polygon_lonlat.txt > pwrap_JH_1.ps

# Raw plot of output of wrapped polygon

gmt psxy -R-0.5/6.75/0/1.5 test_polygon_xy_JH.txt -Jx1i -P -Wfaint -K > pwrap_JH_2.ps
gmt psxy -R test_polygon_xy_JH.txt -J -O -K -Sc1p -Gred >> pwrap_JH_2.ps
gmt psxy -R0/360/0/90 -JH180/6i -O -T -X0.5i -B0 --MAP_FRAME_PEN=faint >> pwrap_JH_2.ps

# Create the left-wrapped and right-wrapped polygons
awk '{printf "%.16g\t%s\n", $1+(($3-1)%2)*$4, $2}' test_polygon_xy_JH.txt > R.txt
awk '{printf "%.16g\t%s\n", $1-(($3)%2)*$4, $2}'   test_polygon_xy_JH.txt > L.txt

# Plot the two polygons
gmt psxy -R-0.5/6.75/0/1.5 L.txt R.txt -Jx1i -P -Wfaint -K > pwrap_JH_3.ps
gmt psxy -R0/360/0/90 -JH180/6i -O -T -X0.5i -B0 --MAP_FRAME_PEN=faint >> pwrap_JH_3.ps

# Finally plot the two polygons and overlay the correct GMT-produced filled polygon
gmt psxy -R-0.5/6.75/0/1.5 L.txt R.txt -Jx1i -P -Wfaint -K > pwrap_JH_4.ps
gmt psxy -R0/360/0/90 -JH180/6i -O -Gred -X0.5i test_polygon_lonlat.txt -B0 --MAP_FRAME_PEN=faint >> pwrap_JH_4.ps

# Polar caps
gmt psxy -R-180/180/-90/-55 -JA-70/-90/1i -Gred -W1p -P -Bafg test_polar_lonlat.txt -K --MAP_FRAME_TYPE=plain --MAP_FRAME_PEN=faint > pwrap_JN_1.ps
gmt psxy -R -J -O -A -W1p << EOF >> pwrap_JN_1.ps
110	-90
110	-55
EOF

# Raw plot of wrapped polygon
gmt psxy -R0/6/0/0.8 -Jx1i -Wfaint test_polar_xy_JN.txt -P -K --MAP_FRAME_PEN=faint > pwrap_JN_2.ps
gmt psxy -R test_polar_xy_JN.txt -J -O -K -Sc2p -Gred >> pwrap_JN_2.ps
gmt psxy -R-180/180/-90/-55 -JN-70/6i -B0 -O -T --MAP_FRAME_PEN=faint >> pwrap_JN_2.ps

gmt psconvert pwrap_J?_?.ps -Tf -P -A+m3p -Z
rm -f L.txt R.txt
