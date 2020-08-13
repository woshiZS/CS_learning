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
      uint32 ip;
      void (*fptr)(int);
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
  3. The origin size of this struct is 16 whereas after I've commented on 

