#include<stdio.h>

int interFunction(int i, int j)
{
    int k = i + j;

    return k;
}

int outerFunction(int i, int j)
{
    int k = interFunction(i, j);

    return k;
}

int main()
{
    int i = 10, j = 20;

    int k = outerFunction(i, j);

    printf("%d", k);

    return 0;
}