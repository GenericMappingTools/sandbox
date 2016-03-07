#!/bin/bash
grep EXTERN_MSC gmt_internals.h | sed -e 's/EXTERN_MSC //g' > tmp
rm -f func.lis
egrep '^bool |^int |^float |^double |^char |^uint64_t |^int64_t |^void ' tmp | tr '(*' '  ' | awk '{if ($2 == "*") {print $3} else {print $2}}' > func.lis
egrep '^enum ^short |^unsigned |^struct ' tmp | tr '(*' '  ' | awk '{if ($3 == "*") {print $4} else {print $3}}' >> func.lis
#exit
while read func; do
	echo "===: $func"
	find . -name '*.c' -exec egrep -H "\b${func}\b" {} \; | awk -F: '{print substr($1,3)}' | sort -u
done < func.lis
