# frozen_string_literal: true

class Solution
  def initialize(input)
    @input = File.readlines(input)
  end

  def solve_first_part
    @detected_passes = []
    @input.each do |boarding_pass|
      @detected_passes << calculate_seat_id(boarding_pass)
    end
    @detected_passes.max
  end

  def solve_second_part
    # Our seat id is guaranteed not to be the highest or lowest
    # seat id, because the puzzle description said so
    min = @detected_passes.min
    max = @detected_passes.max

    (0..127).each do |row|
      (0..7).each do |col|
        id = (row * 8) + col
        return id if id > min && id < max && (!@detected_passes.include? id)
      end
    end
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end

  private

  def calculate_seat_id(boarding_pass)
    row_pattern, col_pattern = boarding_pass.scan(/([FB]{7})([LR]{3})/).first
    row = binary_search(row_pattern.split(''), 'F', [0, 127])
    column = binary_search(col_pattern.split(''), 'L', [0, 7])
    (row * 8) + column
  end

  # Pattern: Search sequence, decoded using `key`
  # Key: This character indicates that the lower range should be searched
  #      Since the input is clean, any character not equal to this one is
  #      the one indicating that the upper range should be searched
  # Range: The range of numbers to be searched
  # This implementation of the function doesn't do error handling, so will
  # bork if input is not just like the Advent of Code input :)
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def binary_search(pattern, key, range)
    if pattern.length == 1
      return range[0] if pattern[0] == key

      range[1]
    else
      if pattern.shift == key
        # search the lower half
        min = range[0]
        # This will be an odd number, but dividing by two results in the floor
        max = ((range[0] + range[1]) / 2)
      else
        # search the upper half
        # This will be an odd number, but dividing by two results in the floor,
        #   so add one to get the new min
        min = ((range[0] + range[1]) / 2) + 1
        max = range[1]
      end
      binary_search(pattern, key, [min, max])
    end
  end
end

# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
input_file = ARGV[0]
Solution.new(input_file).solve
