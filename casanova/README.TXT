# README.TXT for Henri Casanova, Updated Aug. 5, 2017

There are three Bash scripts that perform different calculations that are slow in GMT:

1. spheredist.sh: This script reads a set of coastlines and uses the method of
   Renka [1] to evaluate the distances from each grid node to the nearest coastline.
   The resulting 2x2 arc minute global grid is then imaged, landmasses are overlaid,
   and a PNG @ 300 dpi is produced.  The key calculation is done by sphdistance.c
   which could be optimized via Open MP.

2. spharm.sh: This script evaluates a spherical harmonics model for the topography
   of Venus, up to degree and order 719.  While we have added a basic OpenMP loop
   here it is still very slow and perhaps there are other aspects that could be
   improved.

3. surf.sh: This script runs a finite-difference minimum curvature gridding module
   [2] on a set of input data points.  It can work on very large grids and input
   files but since it does not take advantage of multiple cores.

To run these scripts you will need to install GMT 6.  Please follow the link to
"Building Instructions" in the sidebar on the gmt.soest.hawaii.edu wiki and
build from trunk. Make sure you build it with all the "optional" prerequisites,
such as GDAL, PCRE, LaPack and FFTW [The last two not needed on OS X].

Refs:

[1] Renka, R. J. (1997), STRIPACK: Delauney triangulation and Voronoi diagram on the
    surface of a sphere, ACM Trans. Math. Software, 29(3), 416–434.

[2] Smith, W. H. F., and P. Wessel (1990), Gridding with continuous curvature splines
    in tension, Geophysics, 55(3), 293–305, doi:10.1190/1.1442837.
