#!/bin/bash
# This script takes the downloaded zip content from
# Crameri, F., (2018). Scientific colour-maps. Zenodo
# http://doi.org/10.5281/zenodo.1243862
# and converts the *.cpt files into proper GMT master
# CPT files with correct attribution and hinge info
# Run from the ScientificColourMapsX directory (X is version) after the
# zip has downloaded and been expanded.  But first you need to manually
# update the cpt.info entries below with one line per CPT subdir in the
# downloaded directory.  It will create a gmt subdirectory with all the CPTs.
# You also need to edit gmt_cpt_masters.h after adding the CPTs to share/cpt
#
# Last setup and run for ScientificColourMaps6 on 7/11/2020 for 6.1
# Gave 28 CPTS: The original 24 plus 4 cyclical versions
#
X=6	# The current ScientificColourMaps version
cat << EOF > cpt.info
acton|Perceptually uniform sequential colormap, by Fabio Crameri [C=RGB]
bamako|Perceptually uniform, low-lightness gradient colormap by Fabio Crameri [C=RGB]
batlow|Perceptually uniform ‘rainbow’ colormap by Fabio Crameri [C=RGB]
berlin|Perceptually uniform bimodal colormap, dark, by Fabio Crameri [H=0,C=RGB]
bilbao|a Perceptually uniform colormap by Fabio Crameri [C=RGB]
broc|Perceptually uniform bimodal colormap, light, by Fabio Crameri [H=0,C=RGB]
brocO|Perceptually uniform bimodal cyclic colormap, light, by Fabio Crameri [C=RGB]
buda|Perceptually uniform, low-lightness gradient colormap, by Fabio Crameri [C=RGB]
cork|Perceptually uniform bimodal colormap, light, by Fabio Crameri [H=0,C=RGB]
corkO|Perceptually uniform bimodal cyclic colormap, light, by Fabio Crameri [C=RGB]
davos|a Perceptually uniform colormap by Fabio Crameri [C=RGB]
devon|Perceptually uniform sequential colormap, by Fabio Crameri [C=RGB]
grayC|Perceptually uniform ‘gray’ colormap by Fabio Crameri [C=RGB]
hawaii|Perceptually uniform lush colormap by Fabio Crameri [C=RGB]
imola|Perceptually uniform, low-lightness gradient colormap, by Fabio Crameri [C=RGB]
lajolla|Perceptually uniform colormap, without black or white, by Fabio Crameri [C=RGB]
lapaz|Perceptually uniform ‘rainbow’ colormap by Fabio Crameri [C=RGB]
lisbon|Perceptually uniform bimodal colormap, dark, by Fabio Crameri [H=0,C=RGB]
nuuk|Perceptually uniform, low-lightness gradient colormap, by Fabio Crameri [C=RGB]
oleron|Perceptually uniform topography colormap, by Fabio Crameri [H=0,C=RGB]
oslo|Perceptually uniform, B&W limits, by Fabio Crameri [C=RGB]
roma|Perceptually uniform ‘seis’ colormap by Fabio Crameri [C=RGB]
romaO|Perceptually uniform cyclic colormap by Fabio Crameri [C=RGB]
tofino|Perceptually uniform bimodal colormap, dark, by Fabio Crameri [H=0,C=RGB]
tokyo|Perceptually uniform colormap without black or white, by Fabio Crameri [C=RGB]
turku|a Perceptually uniform colormap by Fabio Crameri [C=RGB]
vik|Perceptually uniform bimodal colormap, light, by Fabio Crameri [H=0,C=RGB]
vikO|Perceptually uniform bimodal cyclic colormap, light, by Fabio Crameri [C=RGB]
EOF
rm -rf gmt
mkdir gmt
while read line; do
	cpt=`echo $line | awk -F'|' '{print $1}'`
	cat <<- EOF > gmt/$cpt.cpt
	#       \$Id\$
	#
	EOF
	echo $line | awk -F'|' '{printf "# %s\n", $2}' >> gmt/$cpt.cpt
	cat <<- EOF >> gmt/$cpt.cpt
	#
	#	www.fabiocrameri.ch/visualisation
	#
	# License: Creative Commons Attribution 4.0 International License
	# Copyright (c) 2018, Fabio Crameri All rights reserved.
	# Crameri, F., (2018). Scientific colour-maps. Zenodo. http://doi.org/10.5281/zenodo.1243862
	# This is ScientificColourMaps version $X
	# Note: Original file converted to GMT version >= 5 CPT format.
	EOF
	if [ "$cpt" = "broc" ] || [ "$cpt" = "cork" ] || [ "$cpt" = "vik" ] || [ "$cpt" = "lisbon" ] || [ "$cpt" = "tofino" ] || [ "$cpt" = "berlin" ] || [ "$cpt" = "oleron" ] ; then
		echo "# Note: Range changed from 0-1 to -1/+1 to place hinge at zero." >> gmt/$cpt.cpt
		cat <<- EOF >> gmt/$cpt.cpt
		#
		#----------------------------------------------------------
		# COLOR_MODEL = RGB
		# HINGE = 0
		#----------------------------------------------------------
		EOF
		# Convert to -1/1 range
		egrep -v '^#|^F|^B|^N' $cpt/$cpt.cpt | awk '{printf "%.6f\t%s/%s/%s\t%.6f\t%s/%s/%s\n", 2*($1-0.5), $2, $3, $4, 2*($5-0.5), $6, $7, $8}' > tmp 
	else
		cat <<- EOF >> gmt/$cpt.cpt
		#
		#----------------------------------------------------------
		# COLOR_MODEL = RGB
		#----------------------------------------------------------
		EOF
		egrep -v '^#|^F|^B|^N' $cpt/$cpt.cpt | awk '{printf "%.6f\t%s/%s/%s\t%.6f\t%s/%s/%s\n", $1, $2, $3, $4, $5, $6, $7, $8}' > tmp 
	fi
	cat tmp >> gmt/$cpt.cpt
	egrep '^F|^B|^N' $cpt/$cpt.cpt | awk '{printf "%s\t%s/%s/%s\n", $1, $2, $3, $4}' >> gmt/$cpt.cpt
done < cpt.info
rm -f tmp
