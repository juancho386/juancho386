#include <stdio.h>
void main() {
	float c,f;
	printf("Celcius | Fahrenheit\n");
	printf("--------------------\n");
	for (c=-30.0;c<=150.0;c=c+10.0) {
		/* c=5*(f-32)/9; */
		f=(c/5*9)+32;
		printf("%7.0f | %6.1f\n",c,f);
	}
}
