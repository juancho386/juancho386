#include <stdio.h>
void main() {
	float c,f;
	printf("Fahrenheit | Celcius\n");
	printf("--------------------\n");
	for (f=0.0;f<=300.0;f=f+20.0) {
		c=5*(f-32)/9;
		printf("%10.0f | %6.1f\n",f,c);
	}
}
