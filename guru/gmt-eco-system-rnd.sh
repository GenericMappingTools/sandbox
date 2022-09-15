#!/usr/bin/env bash
# P. Wessel, Sept 6, 2022
#
# Script for making the 2022 GMT ecosystem rounded-square coaster
# Goals the coasters should achieve:
# 1. Be a square shape with rounded corners
# 2. Make it clear what GMT is
# 3. Show where to learn more
# 4. Indicate what OS it supports
# 5. List all the environments it can be used in
# 6. Indicate NSF support

# Light filled background paper using seashell
# Coaster is 3.5 x 3.5 inches with corner radius 0.125 inch
# Intended for https://www.printglobe.com

gmt begin gmt-eco-system-rnd png,pdf E600,N+gseashell
	# Thick primary and thin secondary rounded frame drawn as symbols
	# Size of 3.5 inch outer rectangle so that outside of the 1p pen matches the dimension
	Wo=$(gmt math -Q 3.5 1 72 DIV SUB =)
	Ro=0.125	# Corner radius of outer rectangle
	echo 0 0 | gmt plot -R-1/1/-1/1 -JX3.5i -W1p -SR${Wo}i/${Wo}i/${Ro}i
	# Inner rectangle should have a gap of 2p then drawn with 0.25p pen
	Wi=$(gmt math -Q ${Wo} 2.25 72 DIV SUB =)
	Ri=$(gmt math -Q ${Ro} ${Wo} ${Wi} SUB 2 DIV SUB =)
	echo 0 0 | gmt plot -W0.25p -SR${Wi}i/${Wi}i/${Ri}i
	# Place GMT logo without any label
	gmt logo -DjCT+w2.75i+o0/0.075i -Sn
	# Add labels and purpose
	echo " 0 0.30 generic-mapping-tools.org"                  | gmt text -F+f11p,Courier-Bold,92/102/132
	echo " 0 0.15 Data Processing \035 Plots \035 Animations" | gmt text -F+f15p,Palatino-Italic,92/102/132
	echo " 0 0 Multi-Platform \035  Multi-Language"           | gmt text -F+f15p,Palatino-Italic,92/102/132
	# Separating line
	gmt plot -W1p <<- EOF
	-0.95	-0.11
	0.95	-0.11
	EOF
	# Place GMT QR code
	echo 0 -0.4 | gmt plot -SkQR_transparent/1i -G92/102/132
	# Ecosystem identifiers
	gmt text -F+f16p,Helvetica-Bold,238/86/52+jCM <<- EOF
	-0.65 -0.22 CMD
	-0.65 -0.4 JULIA
	-0.65 -0.58 MATLAB
	0.65 -0.22 SHELL
	0.65 -0.4 PYTHON
	0.65 -0.58 OCTAVE
	EOF
	# OS supported
	echo "Linux \031 macOS \031 Windows" | gmt text -F+cBC+f14p,Helvetica-Bold,125/168/125 -Dj0/0.385i
	# Funding
	echo "SUPPORTED BY THE US NATIONAL SCIENCE FOUNDATION" | gmt text -F+cBC+f8p,Helvetica-Bold,92/102/132 -Dj0/0.12i
gmt end show
