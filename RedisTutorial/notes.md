## Redis 快速上手

### Data types

* String are binary safe, not rely on terminator with a known length(up to 512 MB)
* Hash: A collection of key value pairs，mainly use ```HMSET, HGETALL```
* List: A simple list of strings, sorted by insertion order, we can add element on the head or the tail.(```lpush or rpush```)
* Sets: An unordered collection of strings, we can add, remove and test for element existence in O(1).(具体参照c++ set)
* Sorted Sets: add element with a score(有点像跳表里面的分数，用于排序，from the smallest score to the greatest score.)

### Commands

1. Run commands on remote serever

```bash
redis-cli -h <ip_address> -p <port_number> -a <password>
```

2. Basic key commands

```bash
SET key value
GET key
DEL key
DUMP key # return the binary form of the value
EXISTS key # if or not a key exists(1 true, 0 false)
EXPIRE key seconds # SET EXPIRE TIME FOR THIS KEY
RENAENX key, newkey
TYPE key
```

3. Basic Hash Commands

```bash
HDEL key field
HMSET key field value field value ... # can store multiple key and values
```

4. Basic LIST commands

```bash
LPUSH key value
RPUSH key value
LRANGE key start end
```

5. Basic SET Commands

```bash
SADD key value
SMEMBERS key # return all values in this key
```

6. Basic SORTED LIST Commands

```bash
ZADD key score member [score2 member2]
ZCARD key # Get the number of members in a sorted set
ZCOUNT key min max # Count 	members within the given value
```

#### Redis HyperLogLog

An algorithm give the approximation of the number of unique elements in a set.

暂时不是太懂，好像就是加几个，最后结果就算几个。

#### Redis SUB/PUB

感觉有点像频道收听的意思，订阅了之后就会收到发布在这个频道的消息。

#### Redis Transactions

* 批量操作在EXEC之前被加入队列缓存
* 收到EXEC之后进入事务执行，事务中其余命令执行失败，其他命令依然执行。
* 事务执行过程中，其他事务的命令不会插入到事务执行的命令序列中。

大致流程就是：

```bash
MULTI
cmd 1
cmd 2
...
last cmd
EXEC # return all result at one time.
```

#### Redis Scripts

Redis使用lua解释器来执行脚本,执行脚本常用命令为```EVAL```。

具体细节也不是太了解，可以看设计与实习中是怎么用的。

Redis与服务器连接主要用的是AUTH指令，或者在开启客户端的时候添加-a参数。

#### Redis Server

服务器这一块的重要指令好像还蛮多的，看设计与实现可以回过头来好好看一下。

## Redis 设计与实现

### 数据结构

#### 简单动态字符串

```c
struct sdshdr{
  int len;
  int free;
  char buf[];
}
```

优点：

* 常数时间复杂度获取字符串长度

* 避免字符串溢出，因为有长度属性，所以在字符串拼接的时候会检查长度是否充足，不够会重新分配足够的空间。

* 减少修改字符串长度带来的内存重新分配次数，

  1. 空间预分配

  小于1MB,多分配一倍的长度，13 + 13 + 1的那个例子

  大于1MB，多分配1MB

  2. 惰性空间释放

  只支持手动释放惰性空间，释放不会自动执行。

* 二进制安全（不以空字符结尾,而是按照len属性来判断）

* 兼容 Cstring.h的部分函数

#### 链表

List键的底层实现，除此之外，发布与订阅，慢查询，监视器等功能也用到了链表。

```c
typedef struct listNode{
  struct listNode *prev;
  struct listNode* next;
  void* Value;
}listNode;

typedef struct list{
  listNode* head;
  listNode* tail;
  // node count in this list
  unsigned long len;
  void *(*dup)(void* ptr);
  void (*free)(void* ptr);
  int (*match)(void *ptr, void *key);
}list;
```

特点：

* 双端，无环，带头尾指针，带链表长度计数器，多态（主要指那三个参数）

#### 字典

hash结构的底层实现

```c
typedef struct dictht{
  dictEntry **table;
  // size of hashtable
  unsigned long size;
  // used to calculate the index
  unsigned long sizemark;
  unsigned long used;
}dictht
```

主要提一下sizemark，这个值和字符串的哈希值一起决定钙元素在哈希表中的位置。

```c
typedef struct dictEntry{
  void *key;
  union{
    void *val;
    uint64_t u64;
    int64_t s64;
  }v;
  // 拉链法解决哈希冲突
  struct dictEntry *next;
}dicEntry;
```

字典（以哈希表作为底层实现）

```c
typedef struct dict{
  // 用于操作特定键值类型的字典的一簇函数
  dictType *type;
  // 传递给上面特定类型函数的可选参数。
  void *privdata;
  dictht ht[2];
  int rehashidx; /* -1 if rehash not in progress */
}
```

* 哈希算法

```c
hash = dict->type->hashFuction(key);
index = hash & dict->ht[x].sizemark;
```

解决冲突的方法上面已经说过了，链地址法（separate chaining）

* rehash

收缩操作和扩展操作，新的哈希表大小都是第一个大于等于ht[0].used*2的2次幂。

新的哈希表位置会根据hash value和size重新计算。全部迁移之后，ht[1]变为ht[0]，然后释放原来ht[0]的内存，并且ht[1]处创建一个新表。

* rehash时间
  1. 没有对磁盘进行写操作，没有fork主进程时，负载因子大于1引发rehash。
  2. 对磁盘进行写操作时，负载因子大于5，触发rehash。
  3. 负载因子小于0.1的时候触发收缩操作。
* 渐进式rehash

如果哈希表内的数据很多，一次性对所有数据rehash会造成服务器瘫痪，所以rehash分为几个步骤：

1. 先给ht[1]分配内存
2. 每次在ht[0]中进行相应item的增删该查操作时，顺便将item重新映射到ht[1]中，没进行一次rehashidx就加一。
3. rehash过程中要用到两个哈希表，查询过程是先查找ht[0]，再查找ht[1]（个人感觉可以看分布比例来决定顺序）

#### 跳表

支持平均O（logN),最坏时间复杂度O(N),并且实现比大多数平衡树要简单，不少程序都使用跳表来代替平衡树。

Sorted List的底层结构就是使用跳跃表实现的。

主要由zskiplist和zskiplistnode组成。