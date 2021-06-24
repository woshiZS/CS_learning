## Basics

* C #中所有的复杂结构（namely class)都是通过new operator进行实例化

* default 修饰符是private级
* namespace也和c++里面很像，但是c++里面用的比较少，c#里面出现的频率很高。

#### Types and Conversions

c#中主要分为四种类型

* Value type

基本上都是内置类型，数值类型，char,bool类型以及struct和enum类型

* Reference type

一般来说class类型属于引用类型，赋值相当于传递引用。

引用类型可以赋值为null，表示这个引用指向空，c#也包含了对空引用类型进行成员方位的异常（类似于dereference a null pointer)

相反的，value type是不可以赋值为null的

内存占用，value type大小除了内存对齐之外，占用大小就是这个数据类型所用的空间。Reference type除了原本的数据占用的空间之外，还需要额外的空间用来存储管理数据。

* Generic type parameters
* Pointer types

#### Numeric Literals

* 有一个表的顺序，按照顺序找到第一个可以容纳该数值类型即为该字面值的类型（一般字面值不是double就是integer，具体的类型以及字面值后缀可以查表
* 数值转换的规则应该所有语言都是类似的，小范围转大范围编译器默认允许，大范围转小范围需要加强制转换（似乎在精度方面没有限制）
* 运算方面，```checked(<expression>)```可以进行移除检查，如果有溢出可以抛出一个异常, 同理```unchecked(<expression>)```可以取消检查（如果你设置了全局检查但是不想再某一个地方进行检查）
* 8bit 和 16 bit的整数类型没有他们的运算符，比那一起在处理的时候会将他们转换为较大的类型然后进行计算，所以在进行复制的时候需要做显示的类型转换。
* nint以及unint，根据处理器位数决定具体大小，在某些运算方面速度更快。并且这两种类型可以和IntPtr/UIntPtr（但是这种类型不可以进行运算，感觉是防止对文件句柄或者地址修改这种操作给🚫掉）进行隐式转换

#### Special Float and double values

* 浮点数具有特殊的类型（感觉和IEE754的规定有关，有的数值表现形式被保留）
* check if a value is NaN, ```float.IsNaN```或者```double.IsNaN```或者使用```object.Equals```
* 另外一个就是decimal和double的区别，前者精度更高，更适合用于金融行业的计算

#### Boolean Values

* 一个比较重要的点就是bool类型不可以和其他类型进行类型转换
* 对于reference type来说，如果两个引用指向同一块内存区域（同一个对象），== 操作符返回的结果是true
* &和|在两个操作数都是bool类型的时候，进行的运算也是and和or，在操作数是number类型的时候才表现为位运算。

#### String and Characters

* System 的char类型占用两个字节，可以用表示Unicode

* char类型也需要destination类型可以容纳两个字节的大小（unsigned)

* 虽然string是引用类型，但是string的比较运算符是基于值类型的比较

  ``` c#
  string a = "test";
  string b = "test";
  Console.Write(a == b); // True
  ```

* c#支持确定的字符串内容，以@开头，不支持escape character. 还可以支持多行string(实际上显示内容就是双引号中的内容)，双引号需要doubled才可以显示

* concatenation operator: +，这中间就和c++比较像，但是这样凭借字符效率比较低，建议使用```System.Text.StringBuilder```

* Interpolated string: 以$开头的字符串可以在字符串中引入被大括号包起来的表达式,可以直接填入变量或者填入序号，后面参数按照C中printf一样传入，每个大括号中的变量还可以加一个冒号再加格式限制符号。（插值字符串必须限制在同一行，要么在之前加上@.

* string不支持直接的大小比较运算符号操作，需要使用string ```CompareTo```方法

#### Arrays

* 连续内存，```Length```获取其长度，长度在创建之后不可以动态的进行变化，```System.Collection``` namespace中含有更advanced的数据结构，dynamically sized arrays and dictionaries.

* 默认初始化为每个字节都初始化为0

* **数组元素的类型是值类型还是引用类型非常重要**，如果是引用类型，数组只会创造固定大小个null reference

  ```c#
  Point[] a = new Point[1000];
  int x = a[500].x;		// 0
  
  public struct Point{public int x, y;} // 貌似c#声明class之后不用加分号...
  
  Point[] a = new Point[1000];
  int x = a[500].x;		// NullReferenceException
  
  public class Point{int x, y;}
  ```

* 数组本身属于引用类型（无论数组元素类型是哪种类型）

* 和python, lua不同，c#取倒数的元素符号为^

  ```c#
  char[] vowels = new char[]{'a', 'e', 'i', 'o', 'u'};
  char lastElement = vowels[^1];	// 'u'
  char secondToLast = vowels[^2];	// 'o'
  ```

  ^0表示数组长度，所以会报错

* Slices: 同样和python, lua不太一样，切片符号用的是double dot，

  ```c#
  char[] firstTwo = vowels[..2];
  char[] lastThree = vowels[2..];
  char middleOne = vowels[2..3];
  // 以上的切片都是基于Range类型
  Range firstTwoRange = 0..2;
  char[] firstTwo = vowels[firstTwoRange];
  ```

* 多维数组

分为两种（传统的矩阵式和锯齿式，感觉后者应该是Z字排列。）

```c#
int[,] matrix = new int[3,3];
// GetLengh(<dimention>) 返回给定维度的size
for（int i = 0; i < matrix.GetLengh(0); ++i)
  for(int j = 0; j < matrix.GetLengh(1); ++j)
    matrix[i,j] = i * 3 + j;
```

Jagged 数组类似于我们常见的多维数组的写法，多个方括号那种，但是书上的写法没有体现出是否可以使用初始化列表来做初始化。(试了一下会报错，Array Initializer can only be used in a variable or field initializer. 类型倒是可以省略，直接使用new来定义也是可以的)

* 关于GC策略，和lua差不多，如果没有varible对相应变量进行引用则会被回收。不可以显示进行内存回收，另外一点就是，静态变量也位于heap，并且生命周期直到整个process结束。

* Definite Assignment

  大概就三点

  * local variables使用之前必须赋值
  * 函数调用之前必须提供参数，除非设定为optional
  * 其他类型在runtime会自动初始化（意思就是说reference type会自动初始化，但是value type这种需要自己手动去处理)

* ```default(<type name>)```可以获取类型的默认值，可以推导的时候也可以省略value type

#### Parameters

主要讲一下三个参数修饰符```in, out, ref```

传值就不用说了，引用类型被传参也是pass by value，只是赋值的引用同样指向一个object。

```c#
StringBuilder sb = new StringBuilder();
Foo(sb);
Console.WriteLine(sb.ToString());		// test

static void Foo(StringBuilder fooSB){
  fooSB.Append("test");
  fooSB = null;
}
```

```ref```：字面意思，参数作为引用传入，需要注意的是，ref在函数定义和调用的时候都要加（貌似c#没有头文件这一说法，所以忽略声明了）

```out```: 和ref类似，差别在于

		1. out修饰的参数在传入之前不需要初始化
  		2. 参数在函数返回之前必须初始化
    		3. out修饰符一般是为了可以有多个返回值，参数做返回值

（还是C的指针方便，搞这么多修饰符反而容易绕晕）

* discard, 这个也和python, lua, go比较像，类似于dumb variable，只相当于一个占位符，但是如果有变量标识符是underscore，这个discard标记就会失效。
* 稍微对比一下，c#里面的引用传参相当于，传了该变量的地址，所有在函数中对这个参数的操作都会影响到原来的变量上。

```in```: 被这个修饰符修饰的参数在函数中无法改变，如果函数有重载（一个有in修饰一个没有），那么在调用的时候需要显示添加修饰符，如果没有则可以不用加（当然加了修饰符也没事）

* params 修饰符，指不定个数的同类型参数，当然也可以传入数组

* Optional parameters 就是给一个默认值就OK了

  ```c#
  void Foo(int x = 23);
  ```

* 除了position argument 之外，还有name position，和python很类似，但是指定的符号是冒号

  ```c#
  Foo(x:1, y:2);
  ```

* position argument 要在name argument之前（混合使用总的顺序要对，实际上这种情况应该非常少见）

* Ref Locals, 简而言之就是将一个变量引用到数组中的一个元素，或者对象的一个field或者是一个local variable（但是不能是property)
* Ref returns: 可以提供一个ref local
* var: 类似于C++ 的auto
* target-typed new expression, 类似于stack里面的emplace，如果编译器可以推导的话，new声明就不用再加类型了
* 赋值expression的值是它被赋的值

#### Null Operators

* null-coalescing operator(??)：如果第一个操作数不为null, 就是原来的值, 否则为第二个操作数

* Null-coalescing assignment operator(??=): 就是说赋值符号左边操作数为空，就赋值，否则不赋值（在lazily calculated properties中特别有用）

* Null-Conditional Operator，

  ```c#
  System.Text.StringBuilder sb = null;
  string s = sb?.ToString();
  ```

  该符号具有短路效应，即如果左边的操作数是null，剩余的表达式都不会去计算。所以在有连续为null的情况下，可以使用连续的null-condition character.就是说连续调用成员的成员的成员这种，可以避免成员为空抛错
  
  **但是有一定需要注意，就是最后的类型要可以为空，像是int类型的话，他不可以为空，所以最后一个类型必须是Nullable Value Types**
  
  我们也可以调用一个方法，如果调用的object是空，相当于没有进行调用

#### Declaration

* 这里有一点和C++不太一样，没有前置声明的说法，变量在后边声明，前面也有效。当然实际使用应该尽量避免同名变量的使用。
* switch得用法里面可以使用goto + <label\>
* switch还可以使用object类型，甚至还可以像条件断点那样，添加when关键字
* switch甚至还可以使用到expression，这里就不细聊了。
* Try和finally好像还有其他规则，这里得等到之后再去看了

#### NameSpace

* using static可以直接使用静态成员
* namespace内部也可以使用using指令
* using也可以用作别名，和alias差不多
* 当引用到同名的namespace但是不同的dll，使用extern来解决模棱两可的应用问题，同时在这之前也要修改XML文件。
* 后面有说到内部class和外部同名namespace中的同名类冲突，个人认为这种情况太过于少见，实际情况中应该尽量避免这种情况的发生。