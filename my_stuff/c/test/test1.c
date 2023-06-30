#include <stdio.h>
void main() {
	long nc=0;
	while (getchar()!=65) {
		++nc;
	}
	putchar(nc);
	printf("lala %ld",nc);
}

