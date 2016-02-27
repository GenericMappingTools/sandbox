#!/bin/bash
# Expects single argument summary.lis
# 1. Generate file for egrep
awk '{print $2}' $1 > a.lis
awk '{printf "\\b%s\\b\n", $1}' a.lis > f.lis
# 2. Find all the source files where these functions are found
find . -name '*.[ch]' -exec grep -H -E -f f.lis {} \; | awk -F: '{print $1}' | sort -u > t.lis
# 3. Generate the sed script to replace things
# replace GMT_with gmt_
sed -e 's/GMT_/gmt_/g' a.lis > b.lis
paste a.lis b.lis | awk '{printf "s/%s/%s/g\n", $1, $2}' > s.lis
# Loop over all files and substitute
while read file; do
	echo "Update $file"
	cp $file $file.save
	sed -f s.lis $file.save > $file
done < t.lis
