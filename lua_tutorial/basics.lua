local x = 10
local name = "Jason"
local isAlive = false
local a = nil

-- Numbers and operators --
local a = 1
local b = 2
local c = a + b
print(c)
print(2^2)

-- increment --
local level = 1
level = level + 1
print(level)

-- Strings --
local str1 = "Jason " 
local str2 = "is really a good guy."
print(str1 .. str2)

print(isAlive)
print(nil)

-- conditional Statements --
local age = 10
if age < 18 then
    print("over 18")
end

-- else if and else
age = 20
if age > 18 then
    print("dog")
elseif age == 18 then
    print("cat")
else
    print("mouse")
end

-- comparison Operators --
a = 3
b = 4
if a ~= b then 
    print("a is not equal to b\n hello man.")
end

-- Combining Statements --
local x = 10
if x == 10 and x < 0 then
    print("dog")
elseif x == 10 or x < 0 then 
    print("cat")
end

-- Nested Statements and invert Value --
local x = 10
local isAlive = true
if x == 10 then
    if not isAlive then 
        print("dog")
    else
        print("cat")
    end
end

-- Functions --
function printTax(price)
    local tax = price * 0.21
    print("tax: "..tax)
end

printTax(200)

-- function return a value --
function calculateTax(price)
    return price * 0.21
end

local result = calculateTax(100)
print(result)

-- reusing the function but this time use variables --
local bread = 130
local milk = 110

local breadTax = calculateTax(bread)
local milkTax = calculateTax(milk)

print("Bread Tax = "..breadTax)
print("Milk Tax = "..milkTax)

-- scope --
function foo()
    local temp = 10
end

print(temp)

local isAlive = true
if isAlive then 
    local temp = 10
end

print(temp) --nil

-- Global Variable No need of local prefix --

-- Loops --
-- while loop --
local i = 0
local count = 0

while i <= 10 do
    count = count + 1
    i = i + 1
end

print("count is "..count)


for i = 1,5 do
    count = count + 1
end
print("count is "..count)

-- Tables --
local colors = {"red", "green", "blue"}

-- This is strange because index starts from 1 not 0.
print(colors[1])
print(colors[2])
print(colors[3])

-- this symbol seems to calculate the number of a table.
for i=1,#colors do
    print(colors[i])
end

-- table manipulation --
table.insert(colors, "orange")
local index = #colors
print(index)

-- insert at index
table.insert(colors, 2, "pink")
for i = 1, #colors do
    print(colors[i])
end

-- remove --
table.remove(colors, 1)
for i=1, #colors do
    print(colors[i])
end

-- Dimensional Table --
local data = {
    {"billy", 12},
    {"John", 20},
    {"andy", 65}
}

for a=1, #data do
    print(data[a][1].." is "..data[a][2].." years old.")
end

-- Key Tables , add square brackets. --
local teams = {
    ["teamA"] = 12,
    ["teamB"] = 15
}

for key,value in pairs(teams) do
    print(key..": "..value)
end

-- uses like map in cpp --
-- Returning a table from a function --
function getTeamScore()
    local scores = {
        ["teamA"] = 12,
        ["teamB"] = 15
    }
    return scores
end

local scores = getTeamScore()
local total = 0
for key, val in pairs(scores) do
    total = total + val
end
print("Total score of all teams: ".. total)

-- Math --
local x = -10
print(math.abs(x))
local a = 10
print(math.abs(a))

-- modules --
require("otherfile")