## Lua Crash Course

* problems about the global variables.why interpret  report that error ?
* function programming is supported in lua.
* support assigm multiple values at one time.
* support break statement.]
* support arbitray number of parameters, hidden as arg , containing n elements.

### Inside the source code（Problems）

* problems: What does the```DefineClass(<classname>)``` stand for?（官方教程里好像说lua没有class的概念，只有类似于继承的东西）
* where does the ```pg``` module located ? 
* container类里面实现circularQueue的时候，清除指定位置的元素，该位置之后的元素不需要向前移动吗？

* 为什么有的时候会将self的table拷贝到local的table再进行操作，有的时候直接对self中的变量进行操作？
* priorityQueue的sink函数是不是写的有问题？
* 游戏中聊天界面好像并不会显示当前的免费聊天次数（而且fix free num的时候好像

### Source code Tips

* 纯粹用table实现小根堆真的很酷，最最重要的还是里面的算法思想（交换以及下沉和上浮）。

#### Calling c++ functions(classes) from lua

* C++在lua中被调用的函数都有如下形式

```c++
typedef int (*lua_CFunction) (lua_State *L);
```

返回值是一个整数，表示的是压入栈中的元素个数，lua_State表示指向栈的指针。

* 可以通过lua_gettop()来获取栈重元素的index，因为lua下表从1开始，所以也代表栈的大小
* lua_pushnumber()将数字push到stack上面
* 我们要告诉lua解释器我们定义了这个函数供lua脚本调用

```c++
/* register */
lua_register(L, "average", average);
```



