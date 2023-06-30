#include <stdio.h>
void main() {
	int c,count;
	while ((c=getchar()) != 65) {
		if (c=='\t') printf("\\t");
		else if (c=='\b') printf("\\b"); /* XXX FAILED HERE */
		else if (c=='\\') printf("\\\\");
		else printf("%c",c);
	}
}
