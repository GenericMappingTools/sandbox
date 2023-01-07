#!/bin/bash
# This shows how we let surface handle requests for pixel-registration.
# Since the algorithm is strictly gridline-registered we must take a few
# steps to fake things:
# We shift the domain by half dx,dy so that the desired lower-left pixel
# is now the lower-left gridline node in the shifted grid.
# 2. We remove the top row and right column
# 3. We change region again to the requested region and mark grid as pixel
# Paul Wessel, January 2023.
Rview=-R-3/17/-3/11
R=-R-2/10/-2/10
gmt begin pixelnodes pdf
	gmt grdmath $R -I1 X = t.nc
	gmt grd2xyz t.nc > nodes.txt
	gmt plot $Rview -Jx0.2i -W2p -Ba4fg1 -l"Grid domain"+H"LEGEND" <<- EOF
	0	0
	8	0
	8	8
	0	8
	0	0
	EOF
	gmt plot -W1p,dotted -l"Padded domain" <<- EOF
	-2	-2
	10	-2
	10	10
	-2	10
	-2	-2
	EOF
	# Shifted nodes
	gmt plot -W0.5p,- -L <<- EOF
	0.5	0.5
	8.5	0.5
	8.5	8.5
	0.5	8.5
	EOF
	gmt plot -Sc3p -Glightred -N nodes.txt -l"Padded nodes"
	gmt select -R0/8/0/8 nodes.txt | gmt plot -Sc3p -W0.5p -Glightblue -N -l"Grid nodes"
	gmt select -R0/7/0/7 nodes.txt | gmt plot -Sx3p -W0.5p -N -D0.1i/0.1i -l"Shifted nodes"
	gmt select -R7.5/8/0/8 nodes.txt | gmt plot -Sx3p -W1p -N -D0.1i/0.1i -l"Discarded nodes"
	gmt select -R0/8/7.5/8 nodes.txt | gmt plot -Sx3p -W1p -N -D0.1i/0.1i
gmt end show
rm -f t.nc nodes.txt
