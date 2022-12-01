require 'pry'

input = IO.read("1.txt").split("\n").map(&:to_i)
result = input.each_cons(2).reduce(0) do |memo, elem|
    if elem.last > elem.first
        memo += 1
    end
    memo
end
puts result