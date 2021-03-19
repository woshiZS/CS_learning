## The Server Side
* From the most basic part.Know about the type alias and macros like```__SOCKADDR_COMMON``` defined in ```sys/types.h``` and ```netinet/in.h``` header file. You should try to find where the definition is and figure it out.

* About the struct sockaddr_in

  ```c
  struct sockaddr_in
    {
      __SOCKADDR_COMMON (sin_);
      in_port_t sin_port;			/* Port number.  */
      struct in_addr sin_addr;		/* Internet address.  */
  
      /* Pad to size of `struct sockaddr'.that is 字节对齐 in Chinese.  */
      unsigned char sin_zero[sizeof (struct sockaddr)
  			   - __SOCKADDR_COMMON_SIZE
  			   - sizeof (in_port_t)
  			   - sizeof (struct in_addr)];
    };
  ```

  We could look further into definition of this macro.

  ```c
  #define	__SOCKADDR_COMMON(sa_prefix) \
    sa_family_t sa_prefix##family
  typedef unsigned short int sa_family_t
  ```

  \## here is a concatenate operator,so the first member in ```sockaddr_in``` is ```sin_family``` .

  and \\ here is a line break mark.

* ```sizeof``` operator and byte alignment

  To test this issue,I write down the following test file.

  ```c
  #include<stdio.h>
  typedef unsigned int uint32;
  typedef unsigned short uint16;
  void func(int a){
      printf("Value of a is %d\n",a);
  }
  struct in_addr{
      uint32 ip;//8 shows when this line is commented
      void (*fptr)(int);//4 shows when this line is commented
  };
  int main(void) {
      void (*fun_ptr)(int) = &func;
      fun_ptr(10);
      printf("%d",sizeof(struct in_addr));
      return 0;
  }
  ```

  1. we cant define a function in a struct in C but we can define a function pointer in its definition like the code above.
  2. Pay attention to the uses of function pointer in C.
  3. The origin size of this struct is 16 whereas after comment each line a different result appeared, **pay attention to the annotations above.**

  Let's step further to see what happens in c++ when we define a function in a struct (or class).

  ```c++
  using uint32 = unsigned int;
  class in_addr{
      unsigned short addr;
      int func(int a){
          printf("The value of a is",a);
          return a;
      }
  };
  int main() {
      cout<<sizeof(in_addr);
      return 0;
  }
  ```

  A little changes have been made,the result is,besides we can definite a function in a struct or class, the same.**And what I wanna put emphasis on is that definite a function in a class dont make the sizeof(in_addr) change!**

* ```sockaddr_in``` mentioned above represent IPV4 address while IPV6 address uses ```sockaddr_in6```

The first function call in main() is ```start(u_short *port) ```,Let's see its functionality.

* 这里说句题外话，关于extern的用法，函数在默认情况下是就是extern类型的，所以加不加extern都一样，但是extern声明variable的话就可以在不引进头文件的情况下进行文件之间的变量共享。

>start calls socket() to return a file descriptor,
>
>![socket](./socket.png)
>
>AF_INET or PF_INET is often passed in as the first argument,the thired argument is usually specified as 0,socket type are recorded in an enum.
>
>```c
>enum __socket_type
>{
>  SOCK_STREAM = 1,		// Sequenced, reliable, connection-based byte streams.
>#define SOCK_STREAM SOCK_STREAM
>  SOCK_DGRAM = 2,		// Connectionless, unreliable datagrams of fixed maximum length.
>#define SOCK_DGRAM SOCK_DGRAM
>  SOCK_RAW = 3,			// Raw protocol interface.
>#define SOCK_RAW SOCK_RAW
>  SOCK_RDM = 4,			// Reliably-delivered messages.
>#define SOCK_RDM SOCK_RDM
>  SOCK_SEQPACKET = 5,    // Sequenced, reliable, connection-based, datagrams of fixed maximum length.
>#define SOCK_SEQPACKET SOCK_SEQPACKET
>  SOCK_DCCP = 6,		/* Datagram Congestion Control Protocol.  */
>#define SOCK_DCCP SOCK_DCCP
>  SOCK_PACKET = 10,		/* Linux specific way of getting packets
>				   at the dev level.  For writing rarp and
>				   other similar things on the user level. */
>#define SOCK_PACKET SOCK_PACKET
>
>  /* Flags to be ORed into the type parameter of socket and socketpair and
>     used for the flags parameter of paccept.  */
>
>  SOCK_CLOEXEC = 02000000,	/* Atomically set close-on-exec flag for the
>				   new descriptor(s).  */
>#define SOCK_CLOEXEC SOCK_CLOEXEC
>  SOCK_NONBLOCK = 00004000	/* Atomically mark descriptor(s) as
>				   non-blocking.  */
>#define SOCK_NONBLOCK SOCK_NONBLOCK
>};
>```
>
>The most common type are SOCK_STREAM and SOCK_DGRAM which represent Tcp and Udp.
>
>* After calling socket(), caller checks if socket() returned -1 or not.Here's error_die() 's definition
>
>```c
>void error_die(const char *sc)
>{
> //包含于<stdio.h>,基于当前的 errno 值，在标准错误上产生一条错误消息。参考《TLPI》P49
> perror(sc); 
> exit(1);
>}
>```
>
>What perror does is just print the failure information based on the passed-in char pointer.
>
>And what happens next is :
>
>```c
> memset(&name, 0, sizeof(name));
> name.sin_family = AF_INET;//usually we use AF_INET here,PF_INET in the function call.
> //htons()，ntohs() 和 htonl()包含于<arpa/inet.h>, 参读《TLPI》P1199
> //将*port 转换成以网络字节序表示的16位整数
> name.sin_port = htons(*port);
> //INADDR_ANY是一个 IPV4通配地址的常量，包含于<netinet/in.h>
> //大多实现都将其定义成了0.0.0.0 参读《TLPI》P1187
> name.sin_addr.s_addr = htonl(INADDR_ANY);//这个宏代表全0
> 
> //bind()用于绑定地址与 socket。参读《TLPI》P1153
> //如果传进去的sockaddr结构中的 sin_port 指定为0，这时系统会选择一个临时的端口号
> if (bind(httpd, (struct sockaddr *)&name, sizeof(name)) < 0)
> 	error_die("bind");
> 
> //如果调用 bind 后端口号仍然是0，则手动调用getsockname()获取端口号
> if (*port == 0)  /* if dynamically allocating a port */
> {
>  int namelen = sizeof(name);
>  //getsockname()包含于<sys/socker.h>中，参读《TLPI》P1263
>  //调用getsockname()获取系统给 httpd 这个 socket 随机分配的端口号
>  if (getsockname(httpd, (struct sockaddr *)&name, &namelen) == -1)
>  	error_die("getsockname");
>  *port = ntohs(name.sin_port);
> }
> 
> //最初的 BSD socket 实现中，backlog 的上限是5.参读《TLPI》P1156，现在这个数字会大得多。
> if (listen(httpd, 5) < 0) 
>  error_die("listen");
> return(httpd);
>```
>
>Functions like htons,htonl,ntohs,ntohl are used for changing byte order so that data order will be independent of specific machine architecture.
>
>bind() is used to bind the socket  to the address.
>
>```c
>int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
>//Returns 0 on success, or –1 on error
>```
>
>Other functions are similar to bind(), all mentioned in TLPI。

**The rest is to accept the connect() socket and process the recieved data.**

Let's step into accept_request function.

```c
/**********************************************************************/
/* A request has caused a call to accept() on the server port to
 * return.  Process the request appropriately.
 * Parameters: the socket connected to the client */
/**********************************************************************/
void accept_request(int client)
{
 char buf[1024];
 int numchars;
 char method[255];
 char url[255];
 char path[512];
 size_t i, j;
 struct stat st;
 int cgi = 0;      /* becomes true if server decides this is a CGI
                    * program */
 char *query_string = NULL;

 //读http 请求的第一行数据（request line），把请求方法存进 method 中
 numchars = get_line(client, buf, sizeof(buf));
 i = 0; j = 0;
 while (!ISspace(buf[j]) && (i < sizeof(method) - 1))
 {
  method[i] = buf[j];
  i++; j++;
 }
 method[i] = '\0';

 //如果请求的方法不是 GET 或 POST 任意一个的话就直接发送 response 告诉客户端没实现该方法
 if (strcasecmp(method, "GET") && strcasecmp(method, "POST"))
 {
  unimplemented(client);
  return;
 }

 //如果是 POST 方法就将 cgi 标志变量置一(true)
 if (strcasecmp(method, "POST") == 0)
  cgi = 1;

 i = 0;
 //跳过所有的空白字符(空格)
 while (ISspace(buf[j]) && (j < sizeof(buf))) 
  j++;
 
 //然后把 URL 读出来放到 url 数组中
 while (!ISspace(buf[j]) && (i < sizeof(url) - 1) && (j < sizeof(buf)))
 {
  url[i] = buf[j];
  i++; j++;
 }
 url[i] = '\0';

 //如果这个请求是一个 GET 方法的话
 if (strcasecmp(method, "GET") == 0)
 {
  //用一个指针指向 url
  query_string = url;
  
  //去遍历这个 url，跳过字符 ？前面的所有字符，如果遍历完毕也没找到字符 ？则退出循环
  while ((*query_string != '?') && (*query_string != '\0'))
   query_string++;
  
  //退出循环后检查当前的字符是 ？还是字符串(url)的结尾
  if (*query_string == '?')
  {
   //如果是 ？ 的话，证明这个请求需要调用 cgi，将 cgi 标志变量置一(true)
   cgi = 1;
   //从字符 ？ 处把字符串 url 给分隔会两份
   *query_string = '\0';
   //使指针指向字符 ？后面的那个字符
   query_string++;
  }
 }

 //将前面分隔两份的前面那份字符串，拼接在字符串htdocs的后面之后就输出存储到数组 path 中。相当于现在 path 中存储着一个字符串
 sprintf(path, "htdocs%s", url);
 
 //如果 path 数组中的这个字符串的最后一个字符是以字符 / 结尾的话，就拼接上一个"index.html"的字符串。首页的意思
 if (path[strlen(path) - 1] == '/')
  strcat(path, "index.html");
 
 //在系统上去查询该文件是否存在
 if (stat(path, &st) == -1) {
  //如果不存在，那把这次 http 的请求后续的内容(head 和 body)全部读完并忽略
  while ((numchars > 0) && strcmp("\n", buf))  /* read & discard headers */
   numchars = get_line(client, buf, sizeof(buf));
  //然后返回一个找不到文件的 response 给客户端
  not_found(client);
 }
 else
 {
  //文件存在，那去跟常量S_IFMT相与，相与之后的值可以用来判断该文件是什么类型的
  //S_IFMT参读《TLPI》P281，与下面的三个常量一样是包含在<sys/stat.h>
  if ((st.st_mode & S_IFMT) == S_IFDIR)  
   //如果这个文件是个目录，那就需要再在 path 后面拼接一个"/index.html"的字符串
   strcat(path, "/index.html");
   
   //S_IXUSR, S_IXGRP, S_IXOTH三者可以参读《TLPI》P295
  if ((st.st_mode & S_IXUSR) ||       
      (st.st_mode & S_IXGRP) ||
      (st.st_mode & S_IXOTH)    )
   //如果这个文件是一个可执行文件，不论是属于用户/组/其他这三者类型的，就将 cgi 标志变量置一
   cgi = 1;
   
  if (!cgi)
   //如果不需要 cgi 机制的话，
   serve_file(client, path);
  else
   //如果需要则调用
   execute_cgi(client, path, method, query_string);
 }

 close(client);
}
```
