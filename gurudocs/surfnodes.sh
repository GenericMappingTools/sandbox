#!/bin/bash
# This shows the general node layout used by surface
# Red are the two boundary row/col values, blue nodes
# lie exactly on the boundary, while white notes are
# the interior nodes.  Here, we show a snapshot when
# C->grid = 8, meaning we are doing a course grid with
# only every 8th node in play (gray).
# Paul Wessel, March 2016.
ps=surfnodes.ps
pdf=surfnodes.pdf
R=-R0/28/0/20
gmt grdmath $R -I1 X = t.nc
gmt psxy $R -Jx0.2i -P -W2p -K -Xc << EOF > $ps
2	2
2	18
26	18
26	2
2	2
EOF
gmt psxy -R -J -O -W0.5p -K << EOF >> $ps
>
10 2
10 18
>
18 2
18 18
>
2 10
26 10
EOF
gmt grd2xyz t.nc | gmt psxy $R -Jx0.2i -P -Sc0.1i -W0.5p -Glightred -N -O -K >> $ps
gmt grd2xyz -R2/26/2/18 t.nc | gmt psxy $R -J -Sc0.1i -W0.5p -Glightblue -N -O -K >> $ps
gmt grd2xyz -R3/25/3/17 t.nc | gmt psxy $R -J -Sc0.1i -W0.5p -Gwhite -N -O -K >> $ps
gmt psxy -R -J -O -K -Sc0.1i -W0.5p -Ggray -N << EOF >> $ps
2	2
2	10
2	18
10	2
10	10
10	18
18	2
18	10
18	18
26	2
26	10
26	18
EOF
gmt psxy -R-2.5/2.5/-2.5/2.5 -JX4i -O -K -W0.5p -X0.8i -Y4.5i << EOF >> $ps
>
-2.5	0
2.5	0
>
0	-2.5
0	2.5
EOF
gmt psxy -R -J -O -K -Sc0.2i -W0.5p -Gwhite -N << EOF >> $ps
0	0
1	0
0	1
-1	0
0	-1
1	1
-1	1
-1	-1
1	-1
2	0
0	2
-2	0
0	-2
EOF
gmt psxy -R -J -O -T >> $ps
gmt psconvert -Tf -P -A -Z $ps
open $pdf
rm -f t.nc

