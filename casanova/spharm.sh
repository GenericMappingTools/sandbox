#!/bin/bash
#
ps=spharm.ps

# Evaluate the first 360 order/degrees of Venus spherical
# harmonics topography model, skipping the L = 0 term (radial mean).
# Output is spharm.pdf
# Wieczorek, M. A., Gravity and topography of the terrestrial planets,
#   Treatise on Geophysics, 10, 165-205, doi:10.1016/B978-044452748-6/00156-5, 2007

gmt sph2grd VenusTopo180.txt -I30m -Rg -Ng -Gv.nc -F1/1/719/719 -V
gmt grd2cpt v.nc -Crainbow -E > t.cpt
gmt grdgradient v.nc -Nt0.75 -A45 -Gvint.nc
gmt grdimage v.nc -Ivint.nc -JG7i -P -Bg -Ct.cpt -Xc > $ps
gmt psconvert -Tf -P -Z $ps
rm -f v*.nc t.cpt
