#include <iostream>
#include <string>
#include <list>
using namespace std;

class Subject;

class Observer{
    protected:
        string name;
        Subject *sub;
    
    public:
        Observer(string name, Subject *sub){
            this->name = name;
            this->sub = sub;
        }
        virtual void update() = 0;
};

class StockObserver :public Observer{
    public:
        StockObserver(string name, Subject* sub) : Observer(name, sub){}
        void update();
};

class NBAObserver : pubic Observer{
    public:
        NBAObserver(string name, Subject *sub) : Observer(name, sub){}
        void update();
};

class Subject{
    protected:
        list<Observer *> observers;
    
    public:
        string action; // status
        virtual void attach(Observer *) = 0;
        virtual void detach(Observer *) = 0;
        virtual void notify() = 0;
};

class Secretary : public Subject{
    void attach(Observer *observer){
        observers.push_back(observer);
    }

    void detach(Observer *observer){
        list<Observer*>::iterator iter = observers.begin();
        while(iter != observers.end()){
            if((*iter) == observer){
                observers.erase(iter);
                return;
            }
            ++iter;
        }
    }
    void notify(){
        auto it = observers.begin();
        while(it != observers.end()){
            (*iter)->update();
            ++iter;
        }
    }
};

void StockObserver::update(){
    cout << name << " received message: " << sub->action << endl;
    if(sub->action == "boss is coming!"){
        cout << "Close stock software and pretend to work hard!" << endl;
    }
}

void NBAObserver::update(){
    cout << name << " received message: " << sub->action << endl;
    if(sub->action == "boss is coming!"){
        cout << "Close nba video software and pretend to work hard!" << endl;
    }
}

int main(){
    Subject *dwq = new Secretary();
    Observer *xs = new NBAObserver("xiaoshuai", dwq);
    Observer *zy = new NBAObserver("zouyue", dwq);
    Observer *lm = new StockObserver("limin", dwq);

    dwq->attach(xs);
    dwq->attach(zy);
    dwq->attach(lm);

    dwq->action = "go lunch!";
    dwq->notify();
    cout << endl;
    dwq->action = "boss is coming!";
    dwq->notify();
    return 0;
}