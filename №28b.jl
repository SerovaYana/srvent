function fib_recurs(n::Integer)
    if n in (0,1)
        return 1
    end
        return fib_recurs(n-2)+fib_recurs(n-1)
end

print(fib_recurs(20))