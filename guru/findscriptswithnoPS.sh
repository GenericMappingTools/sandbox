#!/bin/bash
# This script will find all plot-making test scripts that do
# not yet have a PostScript original file for comparison.

if [ "X$GMT_DEV" = "X" ]; then	# GMT_DEV not set so must insist we are in top dir
	if [ ! -d test ]; then
		echo "findscriptswithnoPS.sh must be run from top gmt dir" >&2
		exit
	fi
else	# GMT_DEV set so we can look in gmt-dev
	pushd .
	cd $GMT_DEV/gmt-dev
fi
# Make list of all test scripts
find test -name '*.sh' > /tmp/t.lis
rm -f /tmp/noPS.log
let n=0
while read file; do
	prefix=`basename $file ".sh"`
	dir=`dirname $file`
	ps=`grep -c "^ps=" $file`
	if [ ! -f $dir/$prefix.ps ] && [ $ps -eq 1 ]; then
		echo "No PostScript original file for script $file"
		echo $file >> /tmp/noPS.log
		let n=n+1
	fi
done < /tmp/t.lis
if [ $n -eq 0 ]; then
	echo "All plot tests have original PostScript files for comparison"
else
	echo "Found $n tests without PostScript files"
	echo "Files listed in /tmp/noPS.log"
fi
rm -f /tmp/t.lis
if [ ! "X$GMT_DEV" = "X" ]; then
	popd
fi
