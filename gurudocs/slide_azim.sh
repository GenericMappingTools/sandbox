#!/bin/bash
# Makes fig3 in slides.tex
gmt begin slides_fig3 png
	gmt basemap -R-1/1/0/1 -JX4i/1i -Bxaf+l"@~g@~" -Byaf+l"s"
	v=2;
	gmt math -T-1/1/0.001 T ABS $v POW = | gmt plot -W1p,red -l"v = 2"+jTC
	v=5
	gmt math -T-1/1/0.001 T ABS $v POW = | gmt plot -W1p,green -l"v = 5"
	v=10
	gmt math -T-1/1/0.001 T ABS $v POW = | gmt plot -W1p,blue -l"v = 10"
	v=100
	gmt math -T-1/1/0.001 T ABS $v POW = | gmt plot -W1p,black -l"v = 100"
gmt end show
