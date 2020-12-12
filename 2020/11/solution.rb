#!/usr/bin/ruby
# frozen_string_literal: true

TRANSLATOR = {
  'L' => :unoccupied,
  '.' => :floor,
  '#' => :occupied,
  :unoccupied => 'L',
  :floor => '.',
  :occupied => '#'
}


class WaitingArea
  # seating is a grid of seats
  attr_accessor :seating
  attr_reader :last_column
  attr_reader :last_row

  def initialize(seating)
    @seating = seating
    @last_column = @seating[0].length - 1
    @last_row = @seating.length - 1
  end

  def to_s
    output = ""
    @seating.each do |row|
      row.each do |sym|
        output += TRANSLATOR[sym]
      end
      output += "\n"
    end
    output
  end

  def cycle!
    loop do
      break unless shuffle
    end
  end

  def get_num_occupied
    total = 0
    @seating.each do |row|
      row.each do |column|
        total += 1 if column == :occupied
      end
    end
    total
  end

  # seat shuffle
  # returns false if nothing changes

  private

  def shuffle
    marked_for_swap = []
    @seating.each_with_index do |columns, i_row|
      columns.each_with_index do |_, i_column|
        marked_for_swap << [i_row, i_column] if should_swap(i_row, i_column)
      end
    end
    marked_for_swap.each do |seat|
      row, column = seat
      swap_state(row, column)
    end
    return marked_for_swap.size > 0
  end

  def swap_state(row, column)
    state = @seating[row][column]
    if state == :unoccupied
      @seating[row][column] = :occupied
    else 
      @seating[row][column] = :unoccupied
    end
  end

  def should_swap(row, column)
    state = @seating[row][column]
    if state == :unoccupied
      return num_adjacent_occupied(row, column) == 0
    elsif state == :occupied
      return num_adjacent_occupied(row, column) >= 4
    else
      false
    end
  end

  def num_adjacent_occupied(row, column)
    adjacent_seats = [
      [row - 1, column - 1],
      [row - 1, column],
      [row - 1, column + 1],
      [row, column - 1],
      [row, column + 1],
      [row + 1, column - 1],
      [row + 1, column],
      [row + 1, column + 1]
    ]

    total = 0
    adjacent_seats.each do |seat|
      total += 1 if seat_in_bounds(seat) && seat_occupied(seat)
    end
    total
  end

  def seat_in_bounds(seat)
    row, column = seat
    row >= 0 && row <= @last_row && column >= 0 && column <= @last_column
  end

  def seat_occupied(seat)
    row, column = seat
    @seating[row][column] == :occupied
  end
end

input_file = ARGV[0]
rows = File.readlines(input_file).map(&:strip)
rows.map! { |row| row.split('').map {|seat| TRANSLATOR[seat] } }

a = WaitingArea.new(rows)
a.cycle!
puts a.get_num_occupied

