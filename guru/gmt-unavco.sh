#!/bin/bash
# Create a GMT logo for gmt GMT/UNAVCO Short course
gmt begin gmt-unavco png
	# Lay down the logo
	gmt logo -R-1/1/-1/1 -Jx1i -DjCM+w2.1i -Sn
	echo "0 0.5 UNAVCO SHORT COURSE 2019" | gmt text -F+f10p,Helvetica-Bold -N
gmt end show
