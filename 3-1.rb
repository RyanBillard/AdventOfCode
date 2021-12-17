require 'pry'

class PowerConsumption
    def initialize
        @bit_length = 0
        @gamma = 0
    end

    def value
        epsilon * @gamma
    end

    def epsilon
        @gamma ^ (2**@bit_length - 1)
    end

    def append_gamma_bit(value)
        @bit_length += 1
        @gamma = (@gamma << 1) | value
    end        
end

class Binary
    attr_reader :bit_length, :int_value

    def initialize(raw_value)
        @bit_length = raw_value.length
        @int_value = raw_value.to_i(2)
    end
end

class BitAccumulator
    def initialize
        @total_count = 0
        @one_count = 0
    end

    def add(value)
        @total_count += 1
        if value == 0b1
            @one_count += 1
        end
    end

    def most_common_bit
        @one_count > (@total_count - @one_count) ? 1 : 0
    end
end

file = "3.txt"
input = IO.read(file).split("\n").map {|el| Binary.new(el) }

pc = PowerConsumption.new
(input.first.bit_length - 1).downto(0) do |column|
    ba = BitAccumulator.new
    input.each do |elem|
        ba.add(elem.int_value[column])
    end
    pc.append_gamma_bit(ba.most_common_bit)
end

puts pc.value