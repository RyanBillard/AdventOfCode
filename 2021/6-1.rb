require 'pry'

Lanternfish = Struct.new(:age) do
    def tick
        if age == 0
            Lanternfish.new(6)
        else
            Lanternfish.new(age - 1)
        end
    end

    def spawn?
        age == 0
    end
end

School = Struct.new(:fish) do
    def tick
        aged_fish = fish.map(&:tick)
        new_fish = fish.select(&:spawn?).map do |_|
            Lanternfish.new(8)
        end
        self.fish = aged_fish + new_fish
    end
end


file = "6.txt"
fish = IO.read(file).split(",").map(&:to_i).map do |input_age|
    Lanternfish.new(input_age)
end
school = School.new(fish)
80.times do |_|
    school.tick
end

puts school.fish.count

