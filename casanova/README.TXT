# README.TXT for Henri Casanova

There are two Bash scripts that perform different calculations that are slow in GMT:

1. spheredist.sh: This script reads a set of coastlines and uses the method of
   Renka [1] to evaluate the distances from each grid node to the nearest coastline.
   The resulting 2x2 arc minute global grid is then imaged, landmasses are overlaid,
   and a PNG @ 300 dpi is produced.  The key calculation is done by sphdistance.c
   which could be optimized via Open MP.

2. spharm.sh: This script evaluates a spherical harmonics model for the topography
   of Venus, up to degree and order 719.  While we have added a basic OpenMP loop
   here it is still very slow and perhaps there are other aspects that could be
   improved.

To run these scripts you will need to install GMT.  Please follow the link to
"Building Instructions" in the sidebar on the gmt.soest.hawaii.edu wiki. Make
sure you build it with all the "optional" prerequisites such as GDAL, PCRE,
LaPack and FFTW [The last two not needed on OSX].

Refs:

[1] Renka, R. J. (1997), STRIPACK: Delauney triangulation and Voronoi diagram on the
    surface of a sphere, ACM Trans. Math. Software, 29(3), 416–434.
