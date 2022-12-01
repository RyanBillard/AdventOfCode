require 'pry'

file = "1.txt"
input = IO.read(file).split("\n")

max = -1
input.chunk_while do |first, second|
  !second.empty?
end.each do |chunk|
  chunk.filter! { |entry| !entry.empty? }
  chunk.map!(&:to_i)
  sum = chunk.sum
  max = [sum, max].max
end

puts max