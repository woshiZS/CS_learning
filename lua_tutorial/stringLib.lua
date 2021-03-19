-- s = "hello world"
-- i, j = string.find(s, "hello")
-- print(i, j)
-- print(string.sub(s, i, j))
-- print(string.find(s, "world"))
-- i, j = string.find(s, "l")
-- print(i, j)
-- print(string.find(s, "lll"))

-- s = string.gsub("Lua is cute", "cute", "great")
-- print(s)
-- s = string.gsub("all lii", "l", "x")
-- print(s)
-- s = string.gsub("Lua is great", "perl", "tcl")
-- print(s)

-- s = "IP: 192.168.0.1"
-- i, j = string.find(s, "IP: %d+.%d+.%d+.%d+")
-- print(string.sub(s, i, j))

-- local s = "<a=snapShot:Jason>sjflkdjflkajsl</a>jkjlkjl"
-- for w in string.gmatch(s,"<a=snapShot:(%w+)>.-</a>?") do
--     print(w)
-- end

local msg = 'hello, world'
print(msg)