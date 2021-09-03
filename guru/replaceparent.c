/* Simple program to assist in changing "GMT->parent" to "API"
 * inside the parse function.
 * Keeping a record of what was done by saving this program
 * in the sandbox.
 * Paul Wessel, 9/2/2021.
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main () {
	char line[512] = {""}, *c = NULL;
	int on = 0;

	while (fgets (line, 512, stdin)) {
		if (!strncmp (line, "static int parse", 16U)) on = 1;
		else if (on && line[0] == '}') on = 0;
		if (on && (c = strstr (line, "GMT->parent,"))) {
			c[0] = '\0';
			printf ("%sAPI,%s", line, &c[12]);
			c[0] = 'G';
		}
		else
			printf ("%s", line);
	}
}
