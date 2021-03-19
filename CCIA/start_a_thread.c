#include<stdio.h>
#include<pthread.h>

typedef struct{
    int a;
    int b;
} myarg_t;

void *my_thread(void* arg){
    myarg_t *args = (myarg_t *) arg;
    printf("args: %d %d\n",args->a,args->b);
    return NULL;
}

int main(int argc,char *argv[]){
    pthread_t p;
    myarg_t args = {10,20};
    int err = pthread_create(&p, NULL, &my_thread, &args);
    pthread_join(p, NULL);
    printf("Main thread ends!");
    return 0;
}
