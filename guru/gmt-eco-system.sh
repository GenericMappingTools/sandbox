#!/usr/bin/env bash
# Script mock up of a GMT ecosystem square sticker, to be refined
# Goals the sticker should achieve:
# 1. Be a square shape
# 2. Make it clear what GMT is
# 3. Show where to learn more
# 4. Indicate what OS it supports
# 5. List all the environments it can be used in
# 6. Indicate NSF support

gmt begin gmt-eco-system png
	# Thick primary and thin secondary frame with very light fill
	gmt basemap -R-1/1/-1/1 -Jx1i -B0 -B+gseashell  --MAP_FRAME_PEN=1p
	gmt plot -W0.25p -L <<-EOF
	-0.98	-0.98
	0.98	-0.98
	0.98	0.98
	-0.98	0.98
	EOF
	# Place logo without label
	gmt logo -DjCT+w1.5i+o0/0.05i -Sn
	# Add label and purpose
	echo " 0 0.25 THE GMT ECOSYSTEM" | gmt text -F+f12p,Helvetica-Bold,92/102/132
	echo " 0 0.10 generic-mapping-tools.org" | gmt text -F+f6p,Helvetica,92/102/132
	echo " 0 -0.01 Data Processing \035 Plots \035 Animations" | gmt text -F+f8.5p,Times-Italic,92/102/132
	# Separating line
	gmt plot -W0.5p <<- EOF
	-0.95	-0.12
	0.95	-0.12
	EOF
	# Place QR code
	echo 0 -0.4 | gmt plot -SkQR/0.55i
	# Ecosystem identifiers
	gmt text -F+f9p,Helvetica-Bold,238/86/52+jCM <<- EOF
	-0.65 -0.22 CMD
	-0.65 -0.4 JULIA
	-0.65 -0.58 MATLAB
	0.65 -0.22 SHELL
	0.65 -0.4 PYTHON
	0.65 -0.58 OCTAVE
	EOF
	# OS supported
	echo "Linux \031 macOS \031 Windows" | gmt text -F+cBC+f8p,Helvetica-Bold,125/168/125 -Dj0/0.18i
	# Funding
	echo "SUPPORTED BY THE US NATIONAL SCIENCE FOUNDATION" | gmt text -F+cBC+f4.75p,Helvetica-Bold,92/102/132 -Dj0/0.05i
gmt end show
