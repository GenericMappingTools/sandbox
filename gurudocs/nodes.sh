#!/bin/bash
# Plot of node layout once a subgrid has been read in
gmt begin nodes pdf
	gmt grdmath -R-2/8/-2/8 -I1 -rp X = n.grd
	gmt psbasemap -R-2/8/-2/8 -JX10c/-10c -Ba0f1g1
	echo 0 0 | gmt plot -Sr4c -Glightgray
	echo 0.2 0.2 | gmt plot -S+6p -W1p
	echo -1.5 7.5 | gmt plot -Sr1c -Gred@50
	echo -1.5 6.5 | gmt plot -Sr1c -Gorange@50
	echo -0.5 7.5 | gmt plot -Sr1c -Gorange@50
	echo -0.5 6.5 | gmt plot -Sr1c -Ggreen@50
	#echo -0.5 5.5 | gmt plot -Sr1c -Glightblue@50
	echo -1.5 -1.5 | gmt plot -Sr1c -Gred@50
	echo -1.5 -0.5 | gmt plot -Sr1c -Gorange@50
	echo -0.5 -1.5 | gmt plot -Sr1c -Gorange@50
	echo -0.5 -0.5 | gmt plot -Sr1c -Ggreen@50
	#echo -0.5 0.5 | gmt plot -Sr1c -Glightblue@50
	gmt grdinfo -R0/6/0/6 -Ib n.grd | gmt plot -W3p
	gmt grd2xyz n.grd | awk '{ if ($1 >= 0) printf "%s %s d@-%d,%d@-\n", $1, $2, $1, $2-0.5}' | gmt text -F+f14p,Times-Italic
	gmt grd2xyz n.grd | awk '{ if ($1 < -1) printf "%s %s z@--2,%d@-\n", $1, $2, $2-0.5}' | gmt text -F+f14p,Times-Italic
	gmt grd2xyz n.grd | awk '{ if ($1 == -0.5) printf "%s %s z@--1,%d@-\n", $1, $2, $2-0.5}' | gmt text -F+f14p,Times-Italic
	gmt plot -W1.5p <<- EOF
	0	-2
	0	8
	EOF
gmt end show
rm -f n.grd
