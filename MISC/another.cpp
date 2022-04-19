#include <iostream>

void add(int a){
    std::cout << "First add func\n";
    return;
}

int add(...){
    std::cout << "Second add func\n";
    return 1;
}
    
int main(int argc, char *argv[])
{
    add(1);
    add("hello");
    return 0;
}