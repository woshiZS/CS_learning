### SomeNotes

* jal: jump and link (save the PC + 4 to $ra and then jump and link to the symbol)
* 注意在使用mars的时候要关闭delayed branch，否则RA中存储的位置不是PC + 4
* beqz: branch on equal zero,顾名思义，等于0的时候执行