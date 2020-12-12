#!/usr/bin/ruby
# frozen_string_literal: true

# Refactoring/Extension ideas:
# - Maybe create some kind of marker class to give to the WaitingArea/Seat Cycler
# - Create a copy of the original seating state before cycling, so that the same input
#   can be put through multiple tolerance tunings
# - Create a cool visual or something :)

TRANSLATOR = {
  'L' => :unoccupied,
  '.' => :floor,
  '#' => :occupied,
  :unoccupied => 'L',
  :floor => '.',
  :occupied => '#'
}.freeze

class WaitingArea
  # seating is a grid of seats
  attr_accessor :seating
  attr_reader :last_column, :last_row

  class Space
    attr_reader :x, :y

    def initialize(row, column)
      @x = row
      @y = column
    end

    def state
      @seating[@x][@y]
    end
  end

  def initialize(seating)
    @seating = seating
    @last_column = @seating[0].length - 1
    @last_row = @seating.length - 1
  end

  def to_s
    output = ''
    @seating.each do |row|
      row.each do |sym|
        output += TRANSLATOR[sym]
      end
      output += "\n"
    end
    output
  end

  def cycle!(tolerance)
    loop do
      marked_for_swap = mark_for_swap(tolerance)
      break if marked_for_swap.size.zero?

      swap_seats(marked_for_swap)
    end
  end

  def num_occupied
    total = 0
    @seating.each do |row|
      row.each do |column|
        total += 1 if column == :occupied
      end
    end
    total
  end

  private

  def mark_for_swap(tolerance)
    marked_for_swap = []
    @seating.each_with_index do |columns, i_row|
      columns.each_with_index do |_, i_column|
        marked_for_swap << [i_row, i_column] if should_swap(i_row, i_column, tolerance)
      end
    end
    marked_for_swap
  end

  def swap_seats(marked)
    marked.each do |seat|
      row, column = seat
      swap_state(row, column)
    end
  end

  def swap_state(row, column)
    opposite = {
      :unoccupied => :occupied,
      :occupied => :unoccupied
    }
    state = @seating[row][column]
    @seating[row][column] = opposite[state]
  end

  def should_swap(row, column, tolerance)
    state = @seating[row][column]
    case state
    when :unoccupied
      num_adjacent_occupied(row, column, tolerance[:adjacent_only]).zero?
    when :occupied
      max_tolerated = tolerance[:num_occupied]
      num_adjacent_occupied(row, column, tolerance[:adjacent_only]) >= max_tolerated
    else
      false
    end
  end

  def num_adjacent_occupied(row, column, only_adjacent)
    lines_of_sight = [
      # top left diagonal
      proc { |r, c| [r - 1, c - 1] },
      # top vertical
      proc { |r, c| [r - 1, c] },
      # top right diagonal
      proc { |r, c| [r - 1, c + 1] },
      # left horizontal
      proc { |r, c| [r, c - 1] },
      # right horizontal
      proc { |r, c| [r, c + 1] },
      # bottom left diagonal
      proc { |r, c| [r + 1, c - 1] },
      # bottom vertical
      proc { |r, c| [r + 1, c] },
      # bottom right diagonal
      proc { |r, c| [r + 1, c + 1] }
    ]

    total = 0
    lines_of_sight.each do |los|
      total += 1 if occupied_in_los(row, column, only_adjacent, los)
    end
    total
  end

  # This function is especially ridiculous, should refactor
  def occupied_in_los(row, column, only_adjacent, los)
    coord = los.call(row, column)
    loop do
      los_row, los_column = coord
      return false unless seat_in_bounds([los_row, los_column])

      state = @seating[los_row][los_column]
      case state
      when :occupied
        return true
      when :unoccupied
        return false
      when :floor
        # continue if we are in Part 2
        return false if only_adjacent

        coord = los.call(los_row, los_column)
      end
    end
  end

  def seat_in_bounds(seat)
    row, column = seat
    row >= 0 && row <= @last_row && column >= 0 && column <= @last_column
  end
end

input_file = ARGV[0]
rows = File.readlines(input_file).map(&:strip)
rows.map! { |row| row.split('').map { |seat| TRANSLATOR[seat] } }

a = WaitingArea.new(rows)
a.cycle!(num_occupied: 5, adjacent_only: false)
puts a.num_occupied
