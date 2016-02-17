#!/bin/bash
# Find all functions in GMT and where they are being called.  We will change
# all lcoal functions to static to limit their scope.
# P. Wessel, Feb. 2016
# Plan is to set #define LOCAL static and use things like
# LOCAL double somelocalfunc (...) to set the scope
function unique {
	awk -F: '{print $1}' | sort -u
}
function Cfind {
	find . -name '*.c' -exec egrep -H "$*" {} \; | unique ;
}

# List of C files
if [ ! -d src ]; then
	echo "Run from trunk"
	exit
fi
# Make list of reasonable C files of interest
find src -name '*.c' | egrep -v 'gmt_url.c|gmtprogram.c|grdfilter_mt.c|kiss_fft|nrutil|cm4_functions|test|pthreads_example|s_rint|script2verbatim|segy_io|triangle.c' > c.lis
rm -rf log
mkdir -p log
while read file; do # For each C file
	#grep -v $file c.lis > theresc.lis # Get a list with all files but this one
	# Determine all the functions in this file
	log=log/`basename $file ".c"`.lis
	echo "Create $log"
	egrep '{$' $file | egrep '^bool |^int |^float |^double |^char |^uint64_t |^int64_t |^void ' | tr '(*' '  ' | awk '{if ($2 == "*") {print $3} else {print $2}}' > tmp
	egrep '{$' $file | egrep '^enum ^short |^unsigned |^struct ' | tr '(*' '  ' | awk '{if ($3 == "*") {print $4} else {print $3}}' >> tmp
	# Eliminate struct and array declarations and main functions
	egrep -v '\[|\]|\{|\}|^main' tmp | sort -u | sed '/^\s*$/d' > $log
	if [ ! -s $log ]; then
		rm -f $log
	fi
	# See where else these functions are being used
done < c.lis
cat log/*.lis > all.log
# Want to determine how many times each of the functions in all.log are called in any of the files in c.lis
rm -f tmp
while read function; do
	n=`Cfind "$function \(" | wc -l`
	echo "$n	$function" >> tmp
	printf "%-40s: %3d\n" $function $n
done < all.log
sort -k 1 -g -r tmp > summary.lis
rm -f tmp all.log c.lis
