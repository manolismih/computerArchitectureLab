#include<stdio.h>

int fib[20005]={0,1,1};

int main()
{
	for (int i=2; i<20000; i++)
		fib[i] = fib[i-1]+fib[i-2];
	int odd=0;
	for (int i=0; i<20005; i++)
		if (fib[i]%2==1) odd++;

	printf("Odd numbers : %d ", odd);
	return 0;
}

		
