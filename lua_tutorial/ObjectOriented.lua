-- 大致就是说lua里面没有class，但是会有单独的object,或者说使用一个特定的object作为prototype --
-- coroutine
co = coroutine.create(
    function()
        print("hi")
    end
)

print(coroutine.status(co))

coroutine.resume(co)

print(coroutine.status(co))
