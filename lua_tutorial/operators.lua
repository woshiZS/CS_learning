-- 第一個參數是false的時候表達式返回第一個操作數，否則返回第二個 --
print(nil and false)
-- or在第一個參數為true的事後返回第一個參數，不然返回第二個參數
if false or nil then
    print("This combination is true")
else 
    print("This combination is false")
end