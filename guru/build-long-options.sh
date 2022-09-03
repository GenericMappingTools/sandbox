#!/usr/bin/env -S bash -e
# Make a list of modules, then determine the list of local options and build
# individual module_inc.h files placed in /tmp for now.  These can be manually
# inserted in those modules that do not yet have any long-option structures and
# then deal with any odd things that applies to a particular module.  All structures
# have blanks for long-option names and hence the conversion cannot do anything.
# We require contributors to add reasonable words for option, directives, and the
# modifiers by examining the documentation page for the module.
#
# Paul Wessel, Sept 3, 2022

if [ ! -d admin ]; then
        echo "build-long-options.sh: Must be run from top-level gmt directory" >&2
        exit 1
fi

gmt --show-classic > /tmp/modules.lis	# List of all core and supplemental modules
while read module; do	# Process each module separately
	file=$(find src -name ${module}.c)	# Find the source C file
	# Get upper case name of module
	UNAME=$(echo ${module} | tr [:lower:] [:upper:])
	# Extract the single-letter upper case options from the local Ctrl structure
	egrep "\tstruct ${UNAME}_[A-Z] " ${file} | awk '{print substr($2,length($2))}' > /tmp/t.lis
	# Add leading structure defining text
	cat << EOF > /tmp/${module}_inc.h
static struct GMT_KEYWORD_DICTIONARY module_kw[] = { /* Local options for this module */
	/* separator, short_option, long_option,
	          short_directives,    long_directives,
	          short_modifiers,     long_modifiers */
EOF
	while read opt; do	# Loop over all local options
		echo "	{ 0, '${opt}', \"\"," >> /tmp/${module}_inc.h	# Place the separator, short- and long option blank strings
		echo "	          \"\",                  \"\"," >> /tmp/${module}_inc.h		# Blank directive info
		echo "	          \"\",                  \"\" }," >> /tmp/${module}_inc.h	# Blank modifier info
	done < /tmp/t.lis
	# End with blank structure
	cat << EOF >>/tmp/${module}_inc.h
	{ 0, '\0', "", "", "", "", ""}  /* End of list marked with empty option and strings */
};
EOF
done < /tmp/modules.lis
