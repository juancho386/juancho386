#include <stdio.h>
void main() { /* ex.1.5 */
	float f;
	printf("Fahrenheit | Celcius\n");
	printf("--------------------\n");
	for (f=300.0;f>=0.0;f=f-20.0) {
		printf("%10.0f | %6.1f\n",f,5*(f-32)/9);
	}
}
