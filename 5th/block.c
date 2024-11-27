#include<stdio.h>
#include<stdlib.h>
int global_var;
int init_global_var = 0;
static int static_global_var;  

void function()
{
    return;
}

int main()
{
    int local_var;
    static int static_local_var;
    int* heap_var = (int*)malloc(sizeof(int));

    printf("local_var: %p\n", &local_var);
    printf("static_local_var: %p\n", &static_local_var);
    printf("heap_var: %p\n", heap_var);
    printf("uninitialized global_var: %p\n", &global_var);
    global_var = 0;
    printf("initialized global_var: %p\n", &global_var);
    printf("preinitialized global_var: %p\n", &init_global_var);
    printf("static_global_var: %p\n", &static_global_var);
    printf("function: %p\n", function);

    free(heap_var);
    
    return 0;
}