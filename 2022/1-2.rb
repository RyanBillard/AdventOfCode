require 'pry'

file = "1.txt"
input = IO.read(file).split("\n")

max = []
input.chunk_while do |first, second|
  !second.empty?
end.each do |chunk|
  chunk.filter! { |entry| !entry.empty? }
  chunk.map!(&:to_i)
  sum = chunk.sum
  max << sum
  max = max.max(3)
end

puts max
puts max.sum