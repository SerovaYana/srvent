function summa(vector, s = 0)
    if length(vector) == 0
        return s
    end
    return summa(vector[1:end-1], s + vector[end])
end

vector = [7, 5, 21]
print(summa(vector))