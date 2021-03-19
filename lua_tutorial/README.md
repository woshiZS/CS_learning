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



# Programming in Lua, 4th ed

### Basics

* 变量被设为nil之后，lua可以逐渐回收那块没有被使用的内存
* 数据类型：nil,Boolean,number, string, userdata, function, thread and table
* and和or表达式的trick: 
  * 对于and，第一个表达式为假返回第一个表达式，否则返回第二个表达式。
  * 对于or，第一个表达式为真返回第一个表达式，否则返回第二个表达式。
  * 所以a:?b:c表达式可以写成a and b or c
* lua的交互模式有很多指令，感觉没有必要记，要用的时候查一下就好了
* lua文件中也又可以获取命令行参数的结果，arg[0]表示文件名，负数index表示文件名之前的操作数，index为1， 2， 3分别代表lua文件执行时候的第一二三个参数。
* 三个点```...```表示可变参数
* 经典的8皇后问题。

### Chapter 3  Numbers

#### Category

* lua5.2之前，number类型用的都是双精度浮点数，5.3之后采用两种形式 -- 64位整数和双精度浮点数。
* 十进制数带指数或者小数点的属于浮点类型，否则属于整数类型。并且浮点数和整数在值相同情况下，等号判定也是相同的（这一点好像在python中也是一样的）。
* 使用string.format（%\<format>, number）可以将数字转为特定形式。

#### Arithmetic operators

* //有点类似整数除法，但是实际上又不太一样，对于操作对象是浮点数的情况，运算结果也是返回小于结果的最接近的整数值。
* 取余运算也可以类似于（x  - x%0.01）这样做，表示的是取x的两位小数精度。
* lua里面也有提供幂操作的运算符 —— ^, 3^2 == 9这样子。

#### Relatinoal Operators

* 相同类型比较值，不同类型直接不相等。

#### Math Library

* 虽然说是伪随机，但是自己在控制台里面尝试的全都出现了不同的数字，另外一种方法就是```math.randomseed(os.time())```
* 提一下modf这个方法，返回距离0最近的整数，并且第二个返回值是该方法丢掉的小数部分。
* 关于round这个方法，当我们想要得到离某个数最近的整数的时候，可以使用```math.floor(x + 0.5)```，但是当x很大的时候，由于float无法表示，所以返回结果我们无法控制，可以经过一些特殊处理，当x是整数时，直接返回那个数，对于浮点数的情况按照原有情况计算```math.floor(x+0.5)```

#### Representation limits

* 主要讲的是整数和浮点数的表示限制，整数是64位，所以是 - 2^63 到 2^63 - 1，浮点数在（-2^53 到 2^53）之间可以准确表示浮点数，对于更大的整数表示，要小心使用，因为会有精度不够的情况出现。（例如：  math.maxinteger + 1.0 == math.maxinteger + 2.0结果为true）
* 进行浮点数转整数的时候注意不能超整数表示范围，注意不能有小数部分。
* 注意不等于和非运算都是用~不是！

### Chapter 4. String

* 和许多脚本语言一样，稍微复杂一点的结构内部是不能改变的，比如说我们不能改变一个字符串，对字符串进行拼接操作会生成一个新的字符串而不是对原有字符串进行操作。
* concat运算符```..```用于拼接两个数字的时候，注意要分隔开，不然会将第一个点和数字认为是小数点。
* 在由数字运算的地方，lua会自动将字符串转化为数字，但是只能转换成浮点数形式，想要转化为整数可以使用tonumber函数，第二个参数代表进制。**但是在做比较运算的时候，lua不会对字符串进行自动转化**。
* UTF-8采用多字节编码，编码的时候采用了前缀不交叉的原则。
* 处理UTF-8编码的时候会用到一些特殊的编码函数，和普通函数的不一样，这个使用的时候需要注意。

### Chapter 5. Tables

* table属于动态分配的，并且程序一般只会操纵表的引用和指针，而不是创建一个新表。

* 对于Table的gc，只有一个程序对一个表没有引用之后，garbage collector才会将table占用的内存回收

* ```lua
  a = {}
  a["time"] = 1
  a.time		-- -> 1
  ```

  注意一下这两种写法是等价的。**但是注意a[x]和a.x不是等价的**。

* 用初始化的形式去创建表，比创建一个空表，再一个一个去赋值要更快。

* 好像没有写成key-value形式就算做array那种？出现的第一个元素index就是1？（这里存疑）

* 这一章也有提到在一个sequence里面有hole的情况。

* 还有一个是safe navigation的情况，index一个nil的value会报错，所以我们可以使用```a or {}```这种语法来确保不会出现这种错误。

* 对于lua的table.insert和table.remove而言，插入和删除非末尾的元素也是有移动位置的代价的，只不过语言实现帮助我们完成了这一步而已。

* lua 5.3之后提供了，move操作支持范围拷贝。

### Chapter 6. Functions

* 有一个小的trick，但函数只有一个参数并且类型属于string字面值或者是table类型的时候也，调用函数可以不用加括号。
* 当函数是表达式或者参数列表中的最后一个时候，会自动调整个数（函数具有多返回值的情况），我们也可以再额外加一个括号让函数只返回一个值。
* 介绍了```table.pack()```将传入参数整理为一个含有所有参数的table。```table.unpack()```刚好与之相反。
* select函数，对于多个参数，第一个参数表示从后面第几个位置取参数。
* lua有tail call elimination，就是说在函数尾部调用一个函数，新调用的函数返回会直接跳转回来上一层的调用地址。这样可以提早释放栈空间,**有一点需要注意的是，只有```return func(args)```这种形式才算尾递归**

### Chapter 7. The External World

