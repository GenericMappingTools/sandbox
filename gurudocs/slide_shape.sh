#!/bin/bash
# Makes fig2 in slides.tex
gmt begin slides_fig2 png
	gmt basemap -R0/1/0/1 -JX4i/1i -Bxaf+l"u" -Byaf+l"q"
	p=-2; u0=$(gmt math -Q 10 $p POW =)
	gmt math -T0/1/0.001 $u0 1 $u0 ADD T $u0 ADD DIV 1 SUB MUL = | gmt plot -W1p,red -l"u@-0@- = 10@+$p@+"
	p=-1; u0=$(gmt math -Q 10 $p POW =)
	gmt math -T0/1/0.01 $u0 1 $u0 ADD T $u0 ADD DIV 1 SUB MUL = | gmt plot -W1p,green -l"u@-0@- = 10@+$p@+"
	p=0; u0=$(gmt math -Q 10 $p POW =)
	gmt math -T0/1/0.01 $u0 1 $u0 ADD T $u0 ADD DIV 1 SUB MUL = | gmt plot -W1p,blue -l"u@-0@- = 10@+$p@+"
	p=1; u0=$(gmt math -Q 10 $p POW =)
	gmt math -T0/1/0.01 $u0 1 $u0 ADD T $u0 ADD DIV 1 SUB MUL = | gmt plot -W1p,black -l"u@-0@- = 10@+$p@+"
	printf "0 1\n1 0\n" | gmt plot -W0.25p,-
gmt end show
