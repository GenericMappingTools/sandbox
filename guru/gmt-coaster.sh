#!/bin/bash
# Create a GMT coaster for a 4" coster.  Max diameter of graphic is 3.75"
gmt begin coaster ps
	gmt set PS_MEDIA 3.75ix3.75i
	# Lay down the logo
	gmt logo -R-1.875/1.875/-1.875/1.875 -Jx1i -DjCM+w3.7i -Sn -X0 -Y0
	# Draw circle for debug only
	echo 0 0 | gmt psxy -W1p -N -Sc4i
	# Place WR code
	echo 0 -1.2 | gmt psxy -SkQR/0.65i
	echo "0 0.95 SUPPORTED BY US NSF" | gmt text -F+f12p,Helvetica-Bold
	# Make an arc of radius 3.5 inches from 20 to 160 degrees around map center and use it to place text
	gmt math -T180/360/1 T -C0 COSD -C1 SIND -Ca 1.75 MUL = path.txt
	gmt psxy path.txt -Wfaint,red -N -Sqn1:+l"generic-mapping-tools.org"+v+f18p,Helvetica-Bold+h
	# Plot again after rotating 180 so it will show upside-down
	gmt psxy path.txt -Wfaint -N -Sqn1:+l"generic-mapping-tools.org"+v+f18p,Helvetica-Bold+h -p180+w0/0
gmt end
# RIP but add 0.125 inch margins so final file is 4x4 inches.
gmt psconvert coaster.ps -TG -Z -E600 -A+m0.125i -P
rm -f path.txt
