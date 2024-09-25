#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main(){
    int j=1;
    char i='a';
    
    while(i<='z'){
        printf("%c",i);
        
        if(j==13){
            printf("\n");
            j=0;
        }
            
        ++i;
        ++j;
    }

    return 0;
}