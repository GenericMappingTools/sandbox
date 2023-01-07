#!/bin/csh
#	$Id$
#
# Draw the four different quandrant situations in surface when
# we need to attach an off-node point to the grid. The 5x5 linear
# system of equations is hard-wired to the relative x,y coordinates
# of points A, B, C, D, with point E in the 1st quadrant.  As E
# lies in the 2nd, 3rd or 4th quadrant we must rotate each quadrant
# example by 90, 180, and 270 degrees, respectively, in order for E
# to again be in the 1st quadrant.  This means we must adjust which
# points serve as A-D in the analysis.  It also means we must always
# use the absolute values of u,v for point E. It also means that
# when E is in the 2nd and 4th quadrant we must swap u and v.

set name = $0
set FIG = $name:r
#------------------------------------------------- 
gmt set PS_SCALE_X 1 PS_SCALE_Y 1
#-------------------------------------------------
gmt grdmath -R-1/1/-1/1 -I1 X Y HYPOT 0 NAN = t.nc
gmt psxy -R0/1/0/1 -JX6.5i -P -W0.5p,- -K -B+t"Original 4 Quadrants" --MAP_TITLE_OFFSET=0.5i << EOF >! $FIG.ps
>
0	0.5
1	0.5
>
0.5	0
0.5	1
EOF
gmt psxy -R -J -O -K -G255/220/220 << EOF -X0.15i -Y0.15i >> $FIG.ps
0.5	0.5
1	0.5
1	1
0.5	1
EOF
gmt pstext -R -J -O -K -X-0.15i -Y-0.15i -F+f24p+jTL -Gwhite -W0.25p -DJ0.1i -N << EOF >> $FIG.ps
-0.05	0.5	3
-0.05	1.05	2
0.5	0.5	4
0.5	1.05	1
EOF
# create background grid
gmt psxy -R-1.2/1.2/-1.2/1.2 -JX3i -O -K -W1p << EOF > back.ps
>
-1.2	-1
1.2	-1
>
-1.2	0
1.2	0
>
-1.2	1
1.2	1
>
-1	-1.2
-1	1.2
>
0	-1.2
0	1.2
>
1	-1.2
1	1.2
EOF
gmt psxy -R -J -O -K -L -W0.25p,. << EOF >> back.ps
-0.5	-0.5
0.5	-0.5
0.5	0.5
-0.5	0.5
EOF
echo 0 0 | gmt psxy -R -J -O -K -Ss0.35i -Gblack >> back.ps
gmt grd2xyz t.nc -s | gmt psxy -R -J -O -K -Sc0.25i -Ggray -W0.25p -N >> back.ps
# 1st quadrant
gmt psxy -R -J -O -K -T -X3.5i -Y3.5i >> $FIG.ps
cat back.ps >> $FIG.ps
gmt psxy -R -J -O -K -Sc0.15i -Gwhite -W0.25p -N << EOF >> $FIG.ps
-1	1
-1	0
0	-1
1	-1
EOF
gmt psxy -R -J -O -K -L -W0.25p,. << EOF >> $FIG.ps
-0.5	-0.5
0.5	-0.5
0.5	0.5
-0.5	0.5
EOF
gmt psxy -R -J -O -K -L -W0.5p,- << EOF >> $FIG.ps
>
0.3 0.415
0.3 0
>
0.3 0.415
0 0.415
EOF
gmt pstext -R -J -O -K -Dj0.125i/0.125i -N -F+f+j<< EOF >> $FIG.ps
-1 1 18p,Helvetica LT NW (A)
-1 0 18p,Helvetica LT W1 (B)
0 -1 18p,Helvetica RT S1 (C)
1 -1 18p,Helvetica RT SE (D)
0.275 0.425 18p,Helvetica LT E
0.3 0.3 48p,Helvetica CM *
0.3 0.05 20p,Times-Italic CT u
0.05 0.4 20p,Times-Italic RM v
EOF
# 2nd quadrant
gmt psxy -R -J -O -K -T -X-3.5i >> $FIG.ps
cat back.ps >> $FIG.ps
gmt psxy -R -J -O -K -Sc0.15i -Gwhite -W0.25p -N << EOF >> $FIG.ps
1	1
1	0
0	-1
-1	-1
EOF
gmt psxy -R -J -O -K -L -W0.5p,- << EOF >> $FIG.ps
>
-0.3 0.415
-0.3 0
>
-0.3 0.415
0 0.415
EOF
gmt pstext -R -J -O -K -Dj0.125i/0.125i -N -F+f+j<< EOF >> $FIG.ps
1 1 18p,Helvetica RT NE
1 0 18p,Helvetica RT E1
0 -1 18p,Helvetica LT S1
-1 -1 18p,Helvetica LT SW
-0.275 0.425 18p,Helvetica RT E
-0.3 0.3 48p,Helvetica CM *
-0.3 0.05 20p,Times-Italic CT u
-0.05 0.4 20p,Times-Italic LM v
EOF
# 3rd quadrant
gmt psxy -R -J -O -K -T -Y-3.5i >> $FIG.ps
cat back.ps >> $FIG.ps
gmt psxy -R -J -O -K -Sc0.15i -Gwhite -W0.25p -N << EOF >> $FIG.ps
-1	1
0	1
1	0
1	-1
EOF
gmt psxy -R -J -O -K -L -W0.5p,- << EOF >> $FIG.ps
>
-0.3 -0.415
-0.3 0
>
-0.3 -0.415
0 -0.415
EOF
gmt pstext -R -J -O -K -Dj0.125i/0.125i -N -F+f+j<< EOF >> $FIG.ps
-1 1 18p,Helvetica LT NW
0 1 18p,Helvetica LT N1
1 0 18p,Helvetica RT E1
1 -1 18p,Helvetica RT SE
-0.275 -0.425 18p,Helvetica RB E
-0.3 -0.525 48p,Helvetica CM *
-0.3 0.25 20p,Times-Italic CT u
-0.05 -0.4 20p,Times-Italic LM v
EOF
# 4th quadrant
gmt psxy -R -J -O -K -T -X3.5i >> $FIG.ps
cat back.ps >> $FIG.ps
gmt psxy -R -J -O -K -Sc0.15i -Gwhite -W0.25p -N << EOF >> $FIG.ps
1	1
0	1
-1	0
-1	-1
EOF
gmt psxy -R -J -O -K -L -W0.5p,- << EOF >> $FIG.ps
>
0.3 -0.415
0.3 0
>
0.3 -0.415
0 -0.415
EOF
gmt pstext -R -J -O -K -Dj0.125i/0.125i -N -F+f+j<< EOF >> $FIG.ps
1 1 18p,Helvetica RT NE
0 1 18p,Helvetica RT N1
-1 0 18p,Helvetica LT W1
-1 -1 18p,Helvetica LT SW
0.275 -0.425 18p,Helvetica LB E
0.3 -0.525 48p,Helvetica CM *
0.3 0.25 20p,Times-Italic CT u
0.05 -0.4 20p,Times-Italic RM v
EOF

#-------------------------------------------------
# Post-processing
gmt psxy -R -J -O -T >> $FIG.ps
gmt psconvert $FIG.ps -Tf -P -A
rm -f t.grd rot.grd back.ps $FIG.ps
open $FIG.pdf

