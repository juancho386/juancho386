#include <stdio.h>
void main() {
	int c,count;
	while ((c=getchar()) != 65) {
		count=(c!=' ')?0:++count;
		if (count <2) printf("%c",c);
	}
}
