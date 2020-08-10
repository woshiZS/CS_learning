# Protecting shared data with mutexes

* 之前有提到过，用```std::mutex```来进行资源的锁定以及解锁，leetcode中按序打印那一题可以知道，可以将锁当做信号量来用，试图lock一个已经上锁的mutex会导致线程堵塞。
* Aside from shared data,return poiters or references or pass into a function as parameters are prone to be modified by malicious software.
* Another data race condition is caused by interfaces.
  ```c++
  stack<int> s;
  if(!s.empty()){
    const int value = s.top();
    s.pop();
    do_something(value);
  }
简单理解就是在thread1调用完empty()检测为非空之后，在thread1调用top()之前，thread2调用了pop()，如果恰巧stack中只有一个元素，这时候就会throw exception.
