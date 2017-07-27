#!/bin/bash
# Run all the modern test scripts
# First remove old modern folders and recreate them
rm -rf test/modern_*
for f in $( ls test ); do 
    if [[ -d "test/$f" ]]; then 
        gmtmodernize --recursive --quiet test/$f test/modern_$f 
    fi 
done
# No step into test dir and run the tests.

cd test
ls -d modern_* > d.lis
while read dir; do
	cd $dir
	ls *.sh > s.lis
	while read script; do
		base=`basename $script '.sh'`
		echo "Running $script"
		if [ -f $base.ps ]; then
			mv $base.ps m_${base}.ps
		fi
		rm -f gmt.conf gmt.history
		cat <<- EOF > gmtest.sh
		#!/bin/bash
		export GMT_SOURCE_DIR="$GMTHOME5/trunk"
		export GMT_SRCDIR=`pwd`
		# Start with proper GMT defaults
		gmt set -Du
		# Now run the original script
		. $script
		rm -f gmt.conf gmt.history
		EOF
		bash gmtest.sh
	done < s.lis
	rm -f s.lis
	cd ..
done < d.lis
rm -f d.lis
cd ..
