#!/bin/bash
#	$Id$
# Dumb bash script that accepts name of a PS-producing GMT script and
# tries accomplish the following tasks:

# 0. Add a gmt set GMT_RUNMODE=modern at top of script (or after first gmt set command, if present)
# 1. Strip off all occurrences of -O and -K
# 2. Strip off any -R -J given with no arguments
# 3. For all PostScript-producing modules, remove output redirection
# 4. Remove any final psxy -R -J -O -T lines completely
# 5. Pick up the intended output PS filename and append gmt psconvert call to finalize the PS file
#
# It assumes only a single PS plot is generated, so things like example_03.sh cannot be used.
# It also assumes we are producing a PS plot, i.e., there are no psconvert calls already.
cat << EOF > PStools.txt
gmtlogo
grdcontour
grdimage
grdvector
grdview
psbasemap
psclip
pscoast
pscontour
pshistogram
psimage
pslegend
psmask
psrose
psscale
pssolar
pstext
pswiggle
psxyz
psxy
pscoupe
psmeca
pspolar
pssac
psvelo
mgd77track
pssegyz
pssegy
EOF
cat << EOF > sed.job
s/ \-O//g
s/ \-K//g
s/\-R //g
s/\-J //g
EOF
ps=`grep -f PStools.txt -c $1`
if [ $ps -eq 0 ]; then
	echo "$0: Not a PostScript-producing GMT script" >&2
	exit
fi
has_set=`grep -c 'gmt set|gmtset' $1`
psfile=`grep '^ps=.*\.ps' $1`
name=`basename $psfile ".ps"`
was_ps=0
while read line; do
	first=`echo $line | awk '{print substr($0,1,1)}'`
	if [ "X$first" = "X#" ] || [ "X$first" = "X" ]; then	# Comment or blank line
		echo $line
		continue
	fi
	ps=`echo $line | grep -f PStools.txt -c`
	this_set=`echo $line | grep -c 'gmt set|gmtset'`
	if [ $this_set -gt 0 ] || [ $has_set -eq 0 ]; then	# Add after another gmtset or there was none to begin with
		echo $line
		echo "gmt set GMT_RUNMODE modern"
		has_set=1
	elif [ $ps -gt 0 ]; then
		echo $line | sed -f sed.job | awk -F'>' '{printf "%s\n", $1}'
	else
		echo $line | sed -f sed.job
	fi
	was_ps=ps
done < $1
echo "gmt psconvert -Tp -F$name"
