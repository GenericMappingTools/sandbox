#!/bin/bash
# This script takes the downloaded zip content from
# Crameri, F., (2018). Scientific colour-maps. Zenodo
# http://doi.org/10.5281/zenodo.1243862
# and converts the *.cpt files into proper GMT master
# CPT files with correct attribution and hinge info
# Run from the ScientificColourMaps3 directory after the
# zip has downloaded and been expanded.  I then added the
# separate dir for batlow from http://www.fabiocrameri.ch/batlow.php.
#

cat << EOF > cpt.info
batlow|perceptually uniform ‘rainbow’ colormap by Fabio Crameri [C=RGB]
berlin|perceptually uniform bimodal colormap, dark, by Fabio Crameri [H=0,C=RGB]
bilbao|a perceptually uniform colormap by Fabio Crameri [C=RGB]
broc|perceptually uniform bimodal colormap, light, by Fabio Crameri [H=0,C=RGB]
cork|perceptually uniform bimodal colormap, light, by Fabio Crameri [H=0,C=RGB]
davos|a perceptually uniform colormap by Fabio Crameri [C=RGB]
grayC|perceptually uniform ‘gray’ colormap by Fabio Crameri [C=RGB]
lajolla|perceptually uniform colormap, without black or white, by Fabio Crameri [C=RGB]
lapaz|perceptually uniform ‘rainbow’ colormap by Fabio Crameri [C=RGB]
lisbon|perceptually uniform bimodal colormap, dark, by Fabio Crameri [H=0,C=RGB]
oleron|perceptually uniform topography colormap, by Fabio Crameri [H=0,C=RGB]
oslo|perceptually uniform, B&W limits, by Fabio Crameri [C=RGB]
roma|perceptually uniform ‘seis’ colormap by Fabio Crameri [C=RGB]
tofino|perceptually uniform bimodal colormap, dark, by Fabio Crameri [H=0,C=RGB]
tokyo|perceptually uniform colormap without black or white, by Fabio Crameri [C=RGB]
turku|a perceptually uniform colormap by Fabio Crameri [C=RGB]
vik|perceptually uniform bimodal colormap, light, by Fabio Crameri [H=0,C=RGB]
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
