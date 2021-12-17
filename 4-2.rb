require 'pry'
require 'set'

class DrawnNumber
    attr_reader :number
    def initialize(number)
        @number = number
    end
end

class Board
    def initialize(rows)
        @numbers_to_entries = {}.merge(*rows.map do |row|
            row.group_by(&:number).transform_values do |value|
                value.first
            end
        end)
        @columns = []
        @rows = []
        rows.each do |row|
            @rows << EntryCollection.new(row)
            row.each_with_index do |entry, index|
                @columns[index] = @columns.fetch(index, EntryCollection.new([]))
                @columns[index].add!(entry)
            end
        end
    end
    
    def mark!(number)
        @numbers_to_entries[number]&.mark!
    end

    def unmark!(number)
        @numbers_to_entries[number]&.unmark!
    end

    def won?
        @rows.any? { |row| row.won? } || @columns.any? { |column| column.won? }
    end

    def sum_of_unmarked_entries
        @numbers_to_entries.values.filter do |entry|
            !entry.marked
        end.map(&:number).sum
    end
end

class EntryCollection
    def initialize(entries)
        @entries = entries
    end

    def won?
        @entries.all? { |entry| entry.marked }
    end

    def add!(entry)
        @entries << entry
    end
end

class Entry
    attr_reader :number, :marked
    def initialize(number, marked = false)
        @number = number
        @marked = marked
    end

    def mark!
        @marked = true
    end

    def unmark!
        @marked = false
    end
end

file = "4.txt"
input = IO.read(file).split("\n")

drawn_numbers = input.delete_at(0).split(",").map(&:to_i).map { |el| DrawnNumber.new(el) }
drawn_numbers_set = drawn_numbers.map(&:number).to_set
boards = input.slice_before { |el| el.empty? }.map { |board_input| board_input.drop(1) }.map do |board_input|
    rows = board_input.map do |row_input|
        row_input.split(" ").map(&:to_i).map do |entry|
            Entry.new(entry, drawn_numbers_set.member?(entry))
        end
    end
    Board.new(rows)
end

last_winner = nil
last_drawn_number = nil
drawn_numbers.reverse.each do |drawn_number|
    last_drawn_number = drawn_number
    boards.each do |board|
        board.unmark!(drawn_number.number)
        if !board.won?
            last_winner = board
            break
        end
    end
    break unless last_winner.nil?
end

last_winner.mark!(last_drawn_number.number)

result = last_winner.sum_of_unmarked_entries * last_drawn_number.number
puts result

