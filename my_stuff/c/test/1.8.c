#include <stdio.h>
void main() {
	int c;
	int tabs=0;
	int blanks=0;
	int newlines=0;
	while ( (c=getchar()) != 'A' ){
		if (c=='\t') ++tabs;
		if (c==' ') ++blanks;
		if (c=='\n') ++newlines;
	}
	printf("Se encontraron:\n\t%d tabs\n\t%d espacios\n\t%d enters\n",tabs, blanks, newlines);
}
