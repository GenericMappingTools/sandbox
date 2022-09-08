#!/usr/bin/env -S bash -e
# Make a list of modules, then determine the list of local options and build
# individual module_inc.h files placed in /tmp/longopt for now for the core
# modules and in /tmp/suppl for the supplemental modules.  These can be manually
# inserted in those modules that do not yet have any long-option structures and
# then deal with any odd things that applies to a particular module.  All structures
# have blanks for long-option names and hence the conversion cannot do anything.
# We require contributors to add reasonable words for option, directives, and the
# modifiers by examining the documentation page for the module.
#
# Script also creates new versions of all modules and saves old in module.c.save
# which adds the include statement to longopt/module_inc.h.
# We also create longopt directories inside each supplement directory. Since I
# cannot automate placing the various supplement files where they need to go
# we copy those manually from /tmp/suppl later
#
# Paul Wessel, Sept 7, 2022

if [ ! -d admin ]; then
        echo "build-long-options.sh: Must be run from top-level gmt directory" >&2
        exit 1
fi
SRC=$(pwd)/src
rm -rf /tmp/suppl
mkdir -p /tmp/suppl
mkdir -p ${SRC}/longopt

gmt --show-classic > /tmp/modules.lis	# List of all core and supplemental modules
while read module; do	# Process each module separately
	file=$(find src -name ${module}.c)	# Find the source C file
	# Get upper case name of module
	UNAME=$(echo ${module} | tr [:lower:] [:upper:])
	# Extract the single-letter upper case options from the local Ctrl structure
	egrep "\tstruct ${UNAME}_[A-Z] " ${file} | awk '{print substr($2,length($2))}' > /tmp/t.lis
	# Add leading structure defining text
	cat << EOF > /tmp/suppl/${module}_inc.h
/*--------------------------------------------------------------------
 *
 *	Copyright (c) 1991-2022 by the GMT Team (https://www.generic-mapping-tools.org/team.html)
 *	See LICENSE.TXT file for copying and redistribution conditions.
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation; version 3 or any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *
 *	Contact info: www.generic-mapping-tools.org
 *--------------------------------------------------------------------*/

#ifndef ${UNAME}_INC_H
#define ${UNAME}_INC_H

/* Translation table from long to short module options, directives and modifiers */

static struct GMT_KEYWORD_DICTIONARY module_kw[] = {
	/* separator, short_option, long_option,
	          short_directives,    long_directives,
	          short_modifiers,     long_modifiers */
EOF
	while read opt; do	# Loop over all local options
		echo "	{ 0, '${opt}', \"\"," >> /tmp/suppl/${module}_inc.h	# Place the separator, short- and long option blank strings
		echo "	          \"\",                  \"\"," >> /tmp/suppl/${module}_inc.h		# Blank directive info
		echo "	          \"\",                  \"\" }," >> /tmp/suppl/${module}_inc.h	# Blank modifier info
	done < /tmp/t.lis
	# End with blank structure
	cat << EOF >>/tmp/suppl/${module}_inc.h
	{ 0, '\0', "", "", "", "", ""}  /* End of list marked with empty option and strings */
};
#endif  /* !${UNAME}_INC_H */
EOF
	# Add include statement in module
	cp -f ${file} ${file}.save
	sed -e '/#include "gmt_dev.h"/a\'$'\n'"#include \"longopt/${module}_inc.h\"" ${file}.save > ${file}
done < /tmp/modules.lis
# Place the core includes in one subdir longopt (suppl must be done manually)
rm -rf /tmp/longopt
mkdir -p /tmp/longopt
gmt --show-classic-core > /tmp/modules.lis	# List of all core and supplemental modules
while read module; do	# Process each module separately
	mv /tmp/suppl/${module}_inc.h ${SRC}/longopt
done < /tmp/modules.lis
# Create subdirs longopt in each supplemental directory
for dir in geodesy gshhg img mgd77 potential segy seis spotter x2sys; do
	mkdir -p ${SRC}/${dir}/longopt
done
