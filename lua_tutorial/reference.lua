local tempTable = {
    item1 = 1,
    item2 = 2,
    item3 = 3
}
-- 简单数据结构赋值不是引用，table的赋值是引用。
local ref = tempTable
ref.item1 = 10
print(ref.item1, tempTable.item1)
-- 下面这个语句不会影响ref，这里相当与重新给了一个地址。
tempTable = nil
print(ref.item1)