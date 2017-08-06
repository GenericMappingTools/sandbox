#!/bin/bash
#
# Evaluate the first 360 order/degrees of Venus spherical
# harmonics topography model, skipping the L = 0 term (radial mean).
# Output is spharm.pdf
# Wieczorek, M. A., Gravity and topography of the terrestrial planets,
#   Treatise on Geophysics, 10, 165-205, doi:10.1016/B978-044452748-6/00156-5, 2007

verbose=-Vl	# Comment this out for a quiet run
# Set output PostScript plot name
ps=spharm.ps
# Evaluate the expansion
gmt sph2grd VenusTopo180.txt -I15m -Rg -Ng -Gvenus.nc -F1/1/719/719 $verbose
# Make a color suitable rainbow colortable
gmt grd2cpt venus.nc -Crainbow -E > t.cpt
# Make a colormap of the results
gmt grdimage venus.nc -I -JG90/30/7i -P -K -Bg -Ct.cpt -Xc > $ps
gmt psscale -Ct.cpt -O -Dx3.5i/7.5i+w6i+h+jBC -Baf >> $ps
# Convert to PDF
gmt psconvert -Tf -P -Z $ps
# Clean up
rm -f t.cpt
echo "spharm.sh: Finished, see spharm.pdf and grid venus.nc"
