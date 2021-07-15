### tutorial 2

* prefab， 在非game模式下，改变prefab的大小可以改变所有prefab实例的大小，但是位置和旋转则由具体实例自己决定，在Game模式下， 实例和prefab之间的联系将中断（意思说改变prefab将不会马上改变所有实例）
* Range属性可以在inspector上添加一个滑动条来调整属性的数值
* render pipeline就是常说的渲染管线，他的功能就是通过一些步骤将一个场景渲染到屏幕上
* 项目package只剩visual studio editor搜索urp才会有显示，搞不懂为什么。
* 改变一个原有prefab的materia直接把那个materia往prefab上面拖就好了

## C # 语言基础

1. 四种类型，数值类型，引用类型，泛型以及指针类型
2. 内置类型除了string以外都是数值类型，除此之外还有struct和enum属于数值类型
3. 以class为关键字声明而非struct属于引用类型，除了要存储成员数据之外，还需要一些空间来存储Object meta data. 引用类型可以被赋值为null（c#有一种措施来防止对null指针进行解引用）。
4. c#一样存在内存对齐
5. decimal一般用于金融之类的高精度计算
6. 字面值的尾缀，用于确定字面值的数据类型
   * F float
   * D double
   * M decimal
   * U uint
   * L long
   * UL ulong
7. 数值类型转换规则，destination必须可以表示source那边的所有数值
8. 浮点数到整数之间的转换，小数部分直接会砍掉，另外和其他编程语言一样，整数类型到浮点数类型可能会丢失精度（这种情况在数值较大的情况下会发生）
9. Overflow: 可以使用checked关键字加括号保卫一个表达式，这样有溢出的时候就会抛出一个异常，同理unchecked可以是表达式的溢出检查失效。
10. 在编译的时候才可以确定的表达式的值，默认会带有溢出检查。除非我们加上unchecked检查
11. 8位和16位的类型缺少自己的操作运算符，运算的时候会转换成更大的类型，所以赋值表达式一般要加上强制类型转换符。
12. IntPtr 和UIntPtr用于表示地址空间或者操作系统的文件句柄之类，这两种类型是不允许进行算术运算的。
13. 