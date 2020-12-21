-- defines a factorial function
function fact (n)
    if n == 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end

-- print("enter a number:")
-- a = io.read("*n") -- reads a number
-- print(fact(a))

function norm(x, y)
    return math.sqrt(x^2 + y^2)
end

function twice(x)
    return 2.0 * x
end

print(arg[0])