#!/bin/bash
# Find all functions in a gmt_*.c file. Used to list all the
# exported functions at the top of the gmt_*.c file as comments.

# P. Wessel, April. 2023
function unique {
	awk -F: '{print $1}' | sort -u
}
function Cfind {
	find . -name '*.c' -exec egrep -H "$*" {} \; | unique ;
}

file=$1
rm -f ~/log
# Determine all the functions in this file
egrep '{$' $file | egrep '^FILE |^bool |^const |^size_t |^int |^float |^double |^char |^uint64_t |^int64_t |^void ' | tr '(*' '  ' | awk '{if ($2 == "*") {print $3} else {print $2}}' > /tmp/dalist
egrep '{$' $file | egrep '^const ' | tr '(*' '  ' | awk '{print $3}' >> /tmp/dalist
#egrep '{$' $file | egrep '^doublereal |^integer |^logical ' | tr '(*' '  ' | awk '{if ($2 == "*") {print $3} else {print $2}}' >> /tmp/dalist
egrep '{$' $file | egrep '^enum ^short |^unsigned |^struct ' | tr '(*' '  ' | awk '{if ($3 == "*") {print $4} else {print $3}}' >> /tmp/dalist
# Eliminate struct and array declarations and main functions
egrep -v '\[|\]|\{|\}|^main' /tmp/dalist | grep -v GMT_LOCAL | sort -u | sed '/^\s*$/d' > ~/log
