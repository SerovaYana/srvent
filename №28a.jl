function fib_norecurs(n)
    f_prev = f_next = 1
    while n > 0
        f_next, f_prev = f_next + f_prev, f_next
        n -= 1
    end
    return f_prev
end

print(fib_norecurs(90))