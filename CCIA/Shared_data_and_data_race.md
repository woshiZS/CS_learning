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
  ```

  简单理解就是在thread1调用完empty()检测为非空之后，在thread1调用top()之前，thread2调用了pop()，如果恰巧stack中只有一个元素，这时候就会throw exception.

这时候会引入一个问题，为什么top()和pop()不合并在一起，原因是栈中元素在全部弹出后才会返回调用函数，如果弹出元素太大或者因为其他原因抛出exception导致调用失败，栈中被弹出元素就会丢失了。

可能的解决方案有三种：

1.第一个就是引用传参，但是也存在缺点，需要额外分配资源；需要提前知道栈中元素类型；需要存储类型是可以赋值的。

2.限制传入存储类型，在拷贝构造的过程中不会抛出异常，或者是移动构造（一般情况下也不会抛出异常），但是这种方法的缺点显而易见了。

3.返回指针，唯一缺点就是需要自己管理内存，这里可以用shared_ptr来管理指针。

**一般采用方案是1，3或者2，3结合，看实际情况对std::stack进行封装，成为一个线程安全的stack.**

### The issue of Deadlock

使用过少的锁，锁住过大范围，会降低性能，但是太多的锁可能会导致死锁问题。
