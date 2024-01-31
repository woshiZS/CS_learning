#include <pthread.h>

class Singleton{
private:
    static pthread_mutex_t mutex;
    static Singleton *instance;
    Singleton(){
        pthread_mutex_init(&mutex, nullptr);
    }
    Singleton(const Singleton& tmp){}
    Singleton& operator=(const Singleton& tmp){}
public:
    static Singleton* getInstance(){
        pthread_mutex_lock(&mutex);
        if(instance == nullptr){
            instance = new Singleton();
        }
        pthread_mutex_unlock(&mutex);
        return instance;
    }
};

Singleton* Singleton::instance = nullptr;
pthread_mutex_t Singleton::mutex;