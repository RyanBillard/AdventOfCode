require 'pry'

Lanternfish = Struct.new(:age) do
    def tick
        if age == 0
            Lanternfish.new(6)
        else
            Lanternfish.new(age - 1)
        end
    end
end

School = Struct.new(:fishes) do
    def tick(days)
        num_fish_by_age = {}
        (0..8).each do |age|
            num_fish_by_age[age] = 0
        end
        fishes.each do |fish|
            num_fish_by_age[fish.age] += 1
        end
        days.times do
            num_fish_to_spawn = num_fish_by_age[0]
            (1..8).each do |age|
                num_fish_by_age[age - 1] = num_fish_by_age[age]
            end
            num_fish_by_age[8] = num_fish_to_spawn
            num_fish_by_age[6] += num_fish_to_spawn
        end
        num_fish_by_age.values.sum
    end
end


file = "6.txt"
fish = IO.read(file).split(",").map(&:to_i).map do |input_age|
    Lanternfish.new(input_age)
end
school = School.new(fish)
result = school.tick(256)

puts result