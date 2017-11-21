#!/bin/bash
# Run on the output of make test to avoid all the fluff and
# just show the actual issues.

cat << EOF > f.grep
Test: 
Command: 
Directory: 
Output:
--------------------
exit status:
<end of output>
Test time =
Test Failed.
end time:
time elapsed:
 completed
ERROR:
exit status:
Test Passed.
start time: 
memtrack errors: 0
[PASS]
EOF
grep -v -f f.grep $1
rm -f f.grep
