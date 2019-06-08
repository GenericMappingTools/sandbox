/* Dump the Dst_all.wdc to a GMT time series for testing
 * Paul Wessel, June 8, 2019
 * Just run Dst2gmt < Dst_all.wdc > Dst.txt
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main () {
	char line[132] = {""}, tmp[5] = {""};
	int dy, y, m, d, h, Dst;
	
	while (fgets (line, 132U, stdin)) {
		dy = (line[3]-'0') * 10 + (line[4] - '0');
		y = (dy > 50) ? 1900 + dy : 2000 + dy;
		m = (line[5]-'0') * 10 + (line[6] - '0');
		d = (line[8]-'0') * 10 + (line[9] - '0');
		for (h = 0; h < 24; h++) {
			strncpy (tmp, &line[20+h*4], 4U);
			Dst = atoi (tmp);
			printf ("%d-%2.2d-%2.2dT%2.2d:00\t%d\n", y, m, d, h, Dst);
		}
	}
}