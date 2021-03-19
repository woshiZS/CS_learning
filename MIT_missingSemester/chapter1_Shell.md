### Some basics

```bash
missing:~$ ls -l /home
drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
```

This gives us a bunch more information about each file or directory present. First, the `d` at the beginning of the line tells us that `missing` is a directory. Then follow three groups of three characters (`rwx`). These indicate what permissions the owner of the file (`missing`), the owning group (`users`), and everyone else respectively have on the relevant item

* connecting programs

```bash
missing:~$ echo hello > hello.txt
missing:~$ cat hello.txt
hello
missing:~$ cat < hello.txt
hello
missing:~$ cat < hello.txt > hello2.txt
missing:~$ cat hello2.txt
hello
```

You can also use >> to append content to a file.

**Another way is to use pipes.**

* sys文件夹下面存储的是kernel parameters的一些设置。
* sudo su: 以root的权限打开shell。
* tee：不仅写到文件中，并且输出到标准输出流。
* xdg-open <filename\> : 用合适的方式打开文件。

### HOMEWORK

* echo内容带有!#之类内容时，即使在双引号中也会有特殊含义，但是使用单引号包括内容就不会进行特殊翻译。

* 使用append符号>>添加时，默认新起一行。

* ```bash
  chmod 744 <filename>
  ```

  表示文件所有者权限为rwx，其他的为r

* ```bash
  #!/bin/sh
  curl --head --silent https://missing.csail.mit.edu
  ```

  第一行告诉shell应该用什么程序来执行这个文件。

* date -r <filename\> 读取文件最近修改的时间。（好好读manual文档，骚操作很多的）