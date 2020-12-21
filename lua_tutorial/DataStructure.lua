-- Arrays 数组大小是不固定的，没有访问越界这一说法，访问越界会返回nil, 命名规范为大小--
A = {}
for i=1, 1000 do
    A[i] = 0
end
-- It is customary to start at insex 1.You can use {} constructors with any number of elements --

-- Matrices and Multi-Dimensional Arrays --
-- 第一种就是直接套娃 ,每一行的元素数量都是动态的 --
MT = {}
for i=1,5 do
  MT[i] = {}
  for j = 1,4 do
    MT[i][j] = 0
  end  
end

-- 第二种就是直接使用乘法 --
MT = {}
for i=1,5 do
    for j=1,5 do
        MT[i*5+j] = i*5+j
    end
end

for i=1,5 do
    for j=1,5 do
        print(MT[i*5+j])
    end
end

-- 使用table更有利于构建稀疏矩阵， 因为只需要初始化需要的值 --

-- Linked Lists 相当于使用头插法--
List = nil
List = {next = List, value = 1}
local l = List
while l do
    print(l.value)
    l = l.next
end

-- Queues and Double Queues --
List = {}
function List.New()
    return {first = 0, last = -1}
end

function List.pushleft(list,value)
    -- list.first = list.first - 1 --
    -- list[list.first] = value --
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function List.pushright(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function List.popleft(list)
    local first= list.first
    if first > list.Last then error("list is empty") end
    local value = list[first]
    list[first] = nil
    list.first = first + 1
    return value
end

-- pop 还要返回被弹出值,每次操作都要更新first和last值 --
function List.pushright(list)
    local last = list.last
    if list.first > last then error("list is empty") end
    local value = list[last]
    list[last] = nil
    list.last = last - 1 
    return value
end

-- Sets and Bags --
function Set(list)
    local set = {}
    for _,l in ipairs(list) do set[l] = true end
     return set
end

Reserved = Set({"while", "end", "function", "local", })
for key, item in pairs(Reserved) do
    print(key,item)
end

-- String Buffers --
-- lua有GC机制，所以要减少中间变量的使用，因此可以使用栈来保存，table.insert来添加新元素，最后用concat来拼接table中的字符串。