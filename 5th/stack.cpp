#include<iostream>
using namespace std;

void testStack()
{
    int i[1024];
    cout << i << endl;
    
    try{
        testStack();
    }
    catch(...){
        cout << "proximate stack size: "<< i;
    }

    return;
}

int main()
{
    testStack();

    system("pause");

    return 0;
}