#include <iostream>

struct Hello{
    int helloworld() { return 0; }
    int forWardFoo(int );
};

struct Generic {
    int anotherFoo(){return 1;}
};

//SFINAE 
template <typename T>
class has_helloworld{

    typedef char one;
    struct two { char x[2]; };

    template <typename C> static one test( decltype(&C::helloworld));
    template <typename C> static two test(...);

    public:
        enum { value = sizeof(test<T>(0)) == sizeof(char) };
};

int main(int argc, char **argv){
    static_assert(has_helloworld<Generic>::value, "Type does not implement helloworld method");
    std::cout << "all check passed" << std::endl;
    return 0;
}

