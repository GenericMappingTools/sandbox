/* Simple program to assist in adding lines like
 * 	n_errors += gmt_M_repeated_module_option (API, Ctrl->F.active);
 * just after the case 'F' in a module, for all cases.
 * Most module options are only allowed once, so we will need to
 * edit for the few that are repetitive (-G in grdtrack, -S in subplot
 * and others).  Keeping a record of what was done by saving this program
 * in the sandbox.
 * Paul Wessel, 9/1/2021.
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main () {
	char line[512] = {""};
	int on = 0;

	while (fgets (line, 512, stdin)) {
		printf ("%s", line);
		if (!strncmp (line, "static int parse", 16U)) on = 1;
		else if (on && line[0] == '}') on = 0;
		if (on && !strncmp (line, "			case '", 9U) && strchr ("><", line[9]) == NULL && isupper (line[9])) {
			printf ("				n_errors += gmt_M_repeated_module_option (API, Ctrl->%c.active);\n", line[9]);
		}
	}
}
