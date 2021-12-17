require 'pry'

class Command
    attr_reader :magnitude

    def initialize(magnitude)
        @magnitude = magnitude
    end

    def apply(position); end
end

class Forward < Command
    def apply(position)
        Position.new(position.horizontal + magnitude, position.vertical + (magnitude * position.aim), position.aim)
    end
end

class Down < Command
    def apply(position)
        Position.new(position.horizontal, position.vertical, position.aim + magnitude)
    end
end

class Up < Command
    def apply(position)
        Position.new(position.horizontal, position.vertical, position.aim - magnitude)
    end
end

class Position
    attr_reader :horizontal
    attr_reader :vertical
    attr_reader :aim

    def initialize(horizontal, vertical, aim)
        @horizontal = horizontal
        @vertical = vertical
        @aim = aim
    end
end

file = "2.txt"
input = IO.read(file).split("\n").map { |el| el.split(" ") }
commands = input.map do |elem|
    direction = elem.first
    magnitude = elem.last.to_i
    case direction
    when "forward"
        Forward.new(magnitude)
    when "down"
        Down.new(magnitude)
    when "up"
        Up.new(magnitude)
    end
end


result = commands.reduce(Position.new(0, 0, 0)) do |position, elem|
    elem.apply(position)
end

puts result.horizontal * result.vertical