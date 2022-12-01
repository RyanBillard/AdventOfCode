require 'pry'

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

    def tied?
        @one_count == @total_count - @one_count
    end

    def value; end
end

class MostCommonBitAccumulator < BitAccumulator
    def value
        most_common_bit
    end

    def most_common_bit
        if tied?
            1
        else
            @one_count > (@total_count - @one_count) ? 1 : 0
        end
    end
end

class LeastCommonBitAccumulator < BitAccumulator
    def value
        least_common_bit
    end

    def least_common_bit
        if tied?
            0
        else
            @one_count > (@total_count - @one_count) ? 0 : 1
        end
    end
end

class BitFilter
    def initialize(list, bit_column, bit_accumulator)
        @list = list
        @bit_column = bit_column
        @bit_accumulator = bit_accumulator
    end

    def filter
        if @list.length == 1
            return @list
        end
        @list.each do |elem|
            @bit_accumulator.add(elem.int_value[@bit_column])
        end

        mask = 1 << @bit_column
        @list.select do |elem|
            if @bit_accumulator.value == 0b1
                elem.int_value.allbits?(mask)
            else
                elem.int_value.nobits?(mask)
            end
        end
    end
end

file = "3.txt"
input = IO.read(file).split("\n").map {|el| Binary.new(el) }

oxygen_candidates = input
co2_candidates = input
(input.first.bit_length - 1).downto(0) do |column|
    oxygen_candidates = BitFilter.new(
        oxygen_candidates,
        column,
        MostCommonBitAccumulator.new
    ).filter
    co2_candidates = BitFilter.new(
        co2_candidates,
        column,
        LeastCommonBitAccumulator.new
    ).filter
end

puts oxygen_candidates.first.int_value * co2_candidates.first.int_value

