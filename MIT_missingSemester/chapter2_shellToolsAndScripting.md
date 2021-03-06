### Tools

* 可以直接赋值，但是不能有多余的空格。

```bash
foo=bar
echo $foo
```

第二个语句会显示bar

* 单双引号在scripting里面是不一样的，双引号中的特殊字符会会被替换成相应的值或者被转义，但是单引号内的内容不会。

```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

$1代表第一个脚本文件的第一个参数。其他更多含义如下

1. `$0` - Name of the script
2. `$1` to `$9` - Arguments to the script. `$1` is the first argument and so on.
3. `$@` - All the arguments
4. `$#` - Number of arguments
5. `$?` - Return code of the previous command
6. `$$` - Process identification number (PID) for the current script
7.  `!!` - Entire last command, including arguments. A common pattern is to execute a command only for it to fail due to missing permissions; you can quickly re-execute the command with sudo by doing `sudo !!`
8. `$_` - Last argument from the last command. If you are in an interactive shell, you can also quickly get this value by typing `Esc` followed by `.`

* 可以使用&&和||符号进行与和或，或运算第一个返回值是true就执行第一个，否则执行第二个，&&运算第一个为true之行第一个和第二个，第一个为false什么都不执行，和普通编程语言的逻辑运算短路差不多。

#### get output of a command into a variable

```bash
foo=$(pwd)
foo
```

第二个会显示当前所在目录，$加括号里面就是指令的内容。**这个的作用就是将一个指令的内容存到一个变量里面。**

#### process substitution

另一个比较重要的运算服就是<()

```bash
diff <(ls foo) <(ls bar)
```

这里是将ls foo和ls bar两个指令的结果存到一个临时文件之中，然后作为diff指令的两个输入，有时候不想存文件而又要将某些特定内容作为输入，就可使用这个指令。

#### test

用于比较，主要使用[[<comparison\>]]， 判定内部表达式的返回值是否为0。shell脚本也可以像编程语言一样写出for循环和条件表达式。

- Wildcards * 代表多个，？代表一个，和正则表达式差不多。
- Curly braces {},命令的参数具有相同前缀的时候可以加大括号，大括号中存放的就是就是后面不同的部分。

#### Shebang

通常指的是是文件第一行，告诉bash应该以何种方式来执行该文件。

后面主要讲了一些函数和脚本文件的区别，还有一些工具的使用：

* tldr 和man类似，但是带了example
* 另外就是find和grep的一些应用，课程主页上都有讲义。





