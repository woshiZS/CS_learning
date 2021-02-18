## SomeNotes

* jal: jump and link (save the PC + 4 to $ra and then jump and link to the symbol)
* 注意在使用mars的时候要关闭delayed branch，否则RA中存储的位置不是PC + 4
* 读内存和写内存指令：```lw&&sw```

```MIPS
lw Rt, Immediate(Rs)
lw Rt, Label
sw Rt, Immediate(Rs)
sw Rt, Label
```

* volatile keyword tells the program to store the variable in the memory instead of immediate value.

#### 3 Addressing ways

* Access by Label
* Register direct access
* Indirect Register memory access
* also can use pointer variables to access the needed value

#### reentrant subprogram

* 这里就是按照sp将栈返回地址压到sp的位置（先压操作数，再压返回地址）
* 记住$s开头的寄存器在函数调用前后不能改变，如果遇到改变的，压栈的时候保存这些需要改变的寄存器，子程序反悔的时候在load回来。