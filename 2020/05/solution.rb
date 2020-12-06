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
    boarding_pass = boarding_pass.gsub(/[FL]/) { '0' }
    boarding_pass = boarding_pass.gsub(/[BR]/) { '1' }
    row = boarding_pass[0...7].to_i(2)
    column = boarding_pass[7..10].to_i(2)
    (row * 8) + column
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
