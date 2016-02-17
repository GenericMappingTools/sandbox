#!/bin/bash
# Find all functions in GMT and where they are being called.  We will change
# all lcoal functions to static to limit their scope.
# P. Wessel, Feb. 2016
# Plan is to set #define LOCAL static and use things like
# LOCAL double somelocalfunc (...) to set the scope
# List of C files
if [ ! -d src ]; then
	echo "Run from trunk"
	exit
fi
find src -name '*.c' > t.lis
rm -rf log
mkdir -p log
while read file; do # For each C file
	#grep -v $file t.lis > therest.lis # Get a list with all files but this one
	# Determine all the functions in this file
	log=log/`basename $file ".c"`.lis
	echo "Create $log"
	egrep '{$' $file | egrep '^bool |^int |^float |^double |^char |^uint64_t |^int64_t |^void ' | tr '(*' '  ' | awk '{if ($2 == "*") {print $3} else {print $2}}' > tmp
	egrep '{$' $file | egrep '^enum ^short |^unsigned |^struct ' | tr '(*' '  ' | awk '{if ($3 == "*") {print $4} else {print $3}}' >> tmp
	# Eliminate struct and array declarations and main functions
	egrep -v '\[|\]|\{|\}|^main' tmp > $log
	if [ ! -s $log ]; then
		rm -f $log
	fi
	# See where else these functions are being used
done < t.lis
rm -f t.lis tmp
