#!/bin/bash
# Makes fig3 in slides.tex
gmt begin slides_azim png
	gmt set FONT_ANNOT_PRIMARY 9p,Times-Italic FONT_LABEL 12p,Times-Italic
	gmt basemap -R-1/1/0/1 -JX4i/1i -Bxaf+l"@~g@~" -Byaf+l"s(@~g@~)"
	v=2;	s_bar=$(gmt math -Q 1 1 $v 1 ADD DIV SUB =)
	gmt math -T-1/1/0.001 1 T ABS $v POW SUB = | gmt plot -W1p,red -l"@%6%p = 2@%%"+jBC
	gmt math -T-1/1/2 $s_bar = | gmt plot -W0.5p,red,-
	v=5;	s_bar=$(gmt math -Q 1 1 $v 1 ADD DIV SUB =)
	gmt math -T-1/1/0.001 1 T ABS $v POW SUB = | gmt plot -W1p,green -l"@%6%p = 5@%%"
	gmt math -T-1/1/2 $s_bar = | gmt plot -W0.5p,green,-
	v=10;	s_bar=$(gmt math -Q 1 1 $v 1 ADD DIV SUB =)
	gmt math -T-1/1/0.001 1 T ABS $v POW SUB = | gmt plot -W1p,blue -l"@%6%p = 10@%%"
	gmt math -T-1/1/2 $s_bar = | gmt plot -W0.5p,blue,-
	v=100;	s_bar=$(gmt math -Q 1 1 $v 1 ADD DIV SUB =)
	gmt math -T-1/1/0.001 1 T ABS $v POW SUB = | gmt plot -W1p,black -l"@%6%p = 100@%%"
	gmt math -T-1/1/2 $s_bar = | gmt plot -W0.5p,black,-
gmt end show
