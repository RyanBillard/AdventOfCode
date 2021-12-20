require 'pry'

Point = Struct.new(:x, :y)

class Line
    attr_reader :start, :finish
    def initialize(start, finish)
        @start = start
        @finish = finish
    end

    def points
        if horizontal?
            start_x, finish_x = [@start.x, @finish.x].sort
            (start_x..finish_x).map do |x_value|
                Point.new(x_value, @start.y)
            end
        elsif vertical?
            start_y, finish_y = [@start.y, @finish.y].sort
            (start_y..finish_y).map do |y_value|
                Point.new(@start.x, y_value)
            end
        else
            []
        end
    end

    def horizontal?
        @start.y == @finish.y
    end

    def vertical?
        @start.x == @finish.x
    end
end


file = "5.txt"
input = IO.read(file).split("\n")
lines = input.map do |input_line|
    start, finish = input_line.split(" -> ").map do |input_point|
        x, y = input_point.split(",").map(&:to_i)
        Point.new(x, y)
    end
    Line.new(start, finish)
end

result = lines.map(&:points).flatten.group_by { |point| point }.filter { |_, value| value.size >= 2 }.keys.count

puts result