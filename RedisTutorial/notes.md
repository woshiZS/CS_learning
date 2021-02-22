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

zskiplist组成：

	1. header: 头结点，不算真正意义上的节点
 	2. tail: 尾节点
 	3. level: 层数最大的那个节点
 	4. length: 记录跳跃表的长度，即跳表当中的节点个数。

zskiplistNode组成:

	1. level: 层级（每层中含有指向下一个节点的指针和两个节点之间的跨度，跨度可以用于计算跳表节点的排位）
 	2. backward: 向后指针
 	3. score: 排序依据（从小到大）
 	4. obj: 指向保存对象的指针

#### 整数集合

当set元素不多，只包含整数元素，会使用整数集合来实现set。

```c
typedef struct intset{
  uint32_t encoding;
  uint32_t length;
  int8_t contents[];
}
```

数组中元素实际大小要根据encoding来算。

* 升级

新添加元素比现有所有类型元素都要长的时，需要进行升级操作，分为三步进行。

	1. 扩展空间，为新元素分配空间。
 	2. 将现有元素换成与新元素相同的类型，并将转换厚的元素放置到正确位置上，保持顺序不变。
 	3. 将新元素添加到数组中。

**注意新元素的摆放位置，要么是最小，要么是最大，所以可以先对原有元素进行重新放置，再放置新元素**

* 降级

Redis不支持自动降级，如果数组中唯一64位元素被删除了，整数集合的编码类型还是64位。

#### 压缩列表

ziplist 是列表和哈希的底层实现之一。一个压缩列表内部包含任意多个节点，每个节点可以保存一个字节数组或者一个整数值。

* zlbytes uint32_t 整个ziplist所占内存字节数
* Zltail uint32_t 尾节点距压缩列表的起始地址有多少个字节，用于快速定位尾节点的位置。
* zllen uint16_t 包含节点数量
* entryX 内容是具体情况而定
* zlend uint_8 记录压缩列表的末端

##### 压缩列表节点构成

1. Previous_entry_length

前一个节点的长度，使用前缀不重复来进行编码，小于254为一字节记录长度，大于为4字节记录长度，所以可以从尾节点从后往前遍历整个压缩列表

2. encoding

**也是采用前缀不重合来进行压缩，这一点在压缩算法里面很重要**， 具体哪种编码对应字符数组，哪种对应整数，可以自己去查，这里不详细阐述。

3. content

##### 连锁更新

因为记录前一个节点长度的位置有可能是一个字节，所以当有连续的250到253字节长的节点出现时，在这些节点的前面加一个长度大于254的节点，那么会导致连锁的更新previous_entry_length的情况出现。

#### 对象

redis中的每一个对象都由redisObject结构表示

```c
typedef struct redisObject {
  unsigned type;
  unsigned encoding;
  void *ptr;
}
```

* 类型

```c
enum{
  REDIS_STRING,
  REDIS_LIST,
  REDIS_HASH,
  REDIS_SET,
  REDIS_ZSET
}valueType;
```

key肯定是string类型，使用TYPE或者称呼的时候返回的是key对应的value类型。

* 编码和底层实现

ptr指向底层实现的数据结构，数据结构有对象的encoding来表示。

使用OBJECT ENCODING可以查看value对象的编码类型。

每种对象对应多种编码类型，有利于灵活性和提升效率，在不同情况，底层实现会互相转换。

##### 字符串对象

int(整数值，可以用long来存储)， embstr(长度小于等于32字节)和raw（长度大于32字节，需要两次内存分配和释放，内存地址不连续）

embstrd字符串对象默认只读，做修改之后会变为raw字符串对象。

相同命令对不同底层实现也不一样，细节可以去看书或者源码。

##### 列表对象

ziplist或者linkedlist,其中每个节点的对象指针指向的是字符串对象（唯一被嵌套的编码类型）

转换情况：存储字符串元素长度小于64字节，保存元素数量小于512个。两者有一个不满足站变为linkedlist

##### 哈希对象

ziplist或者hashtable，前者插入键值对的时候，现在尾部插入key，再在为尾部插入value，成对进行操作。

转换情况：所有key,value长度均小于64字节，哈希对象保存键值对数量小于512个，两者有一个不满足则使用hashtable编码。

##### 集合对象

intset或者hashtable

转换情况：所有元素都是整数，集合对象保存元素数量不超过512个。

##### 有序集合对象

ziplist或者skiplist(其实是zset,一个字典和一个跳跃表)

```c
typedef struct zset{
  zskiplist *zsl;
  dict *dict;
}zset;
```

字典主要用语是实现从元素到其分值的映射，其他操作都由跳表完成。（注意元素成员和分值使用的指针来共享，所以不会浪费多余的内存）

转换情况：元素数量小于128个，保存的所有成员长度都小于64字节，两者有一个不满足则使用hashtable编码。

##### 类型检查和命令多态

总的来说，命令会检查对象类型和编码类型去调用不同的方法

##### 内存回收和对象复用

通过引用计数实现，可以最大进度的节省内存。

##### 对象空转时长

redisObject中包含上次使用时间，使用OBJECT IDLETIME <keyname>可以查看空转时间（now-redisObject.lru)，当设置了内存限制时，默写情况下会先释放空转时间长的key所对应的内存。

