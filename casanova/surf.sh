#!/bin/bash
# Grid topo_1m.xyz using minimum curvature cubic splines
# with a convergence limit to 1 cm and <= 1000 iterations per grid step.
verbose=-V	# Comment this out for a quiet run
# Set output PostScript plot name
ps=surf.ps
# Request time stamps with elapsed time in session
gmt set TIME_REPORT elapsed
# Run surface usinga 0.01 convergence criterion
gmt surface topo_1m.xyz -R80W/64W/34N/42N -I30s -N1000 -C0.01 -Am -Z1.4 $verbose -Gtopo_surf.nc
# Get a rainbow color table scaled to data range
gmt makecpt -Crainbow -T-5400/1500/500 -Z > t.cpt
# Plot gridded result
gmt grdimage topo_surf.nc -I -Ct.cpt -JM9i -Baf -BWSne -K -Xc > $ps
# Overlay coastline
gmt pscoast -Rtopo_surf.nc -J -O -K -W0.25p -Dh >> $ps
# Place color bar
gmt psscale -Ct.cpt -DJCT -Baf -R -J -O >> $ps
# Convert to PDF
gmt psconvert -Tf -P -Z $ps
# Clean up
rm -f t.cpt gmt.conf gmt.history
echo "surf.sh: Finished, see surf.pdf and grid topo_surf.nc"
# open surf.pdf
