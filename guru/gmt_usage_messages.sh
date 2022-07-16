#!/bin/bash
# This script helps examine how all the module usage strings appear and can be
# used to look for subtle variations across modules.  To use this, you must first
# include (or uncomment) the line
#
# add_definitions(-DDEBUG_USAGE_OPTIONS)
# to your ConfigUserAdvanced.cmake and rebuild GMT, then run this script and examine
# the outout which is sent to stdout
#
# Options where [ and ] are not balanced in number are flagged with CHECK!
#
# P. Wessel 7/16/2022

# List of things to grep away
cat << EOF > /tmp/grep.txt
^-	
\[core\]
\[geodesy\]
\[gshhg\]
\[img\]
\[mgd77\]
\[potential\]
\[segy\]
\[seis\]
\[spotter\]
\[x2sys\]
EOF
cat << EOF > /tmp/count.c
#include <stdio.h>
int main () {
	int o = 0, c = 0, a = 0, b = 0, L;
	while ((L = getchar()) != EOF) {
		if (L == '[') o++;
		if (L == ']') c++;
		if (L == '<') a++;
		if (L == '>') b++;
		if (L == '\n') {
			if (o != c)
				printf ("\t CHECK []");
			if (a != b)
				printf ("\t CHECK <>");
			o = c = a = b = 0;
		}
		putchar (L);
	}
}
EOF
cc /tmp/count.c -o /tmp/count
# Get a list of all the modules
gmt --show-modules > /tmp/modules.txt
rm -f /tmp/full_dump.txt
while read module; do
    gmt ${module} - 2> /tmp/one_dump.txt    # Raw dump of this modules options
    # Eliminate junk lines then output records with one option and the module name and append to dump
    awk -v name=${module} '{if (substr($1,1,1) == "-" || substr($1,1,1) == "[") printf "%s\t%s\n", $0, name}' /tmp/one_dump.txt | egrep -f /tmp/grep.txt -v >> /tmp/full_dump.txt
done < /tmp/modules.txt
# Sort the listing and write to stdout
sort -u /tmp/full_dump.txt | /tmp/count
rm -f /tmp/modules.txt /tmp/full_dump.txt /tmp/one_dump.txt /tmp/count.c /tmp/count