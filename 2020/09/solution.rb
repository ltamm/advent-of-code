# frozen_string_literal: true

class Solution
  def initialize(input)
    # Process input
    @input = File.readlines(input).map { |n| n.strip.to_i }
    @preamble_length = 25
  end

  def solve_first_part
    @invalid_index = -1

    (@preamble_length...@input.length).each do |n|
      num = @input[n]
      start = n - @preamble_length
      preamble = @input[start...n]
      found = false
      preamble.each do |p|        
        diff = num - p
        if preamble.include? diff
          found = true
          break
        end
      end
      # if we reach this point, it doesn't follow the pattern
      unless found
        @invalid_index = n
        break
      end
    end
    @input[@invalid_index]
  end

  def solve_second_part
    target = @input[@invalid_index]
    lower = 0
    upper = 1

    while upper < @input.length
      sum = @input[lower..upper].sum
      if sum == target
        min = @input[lower..upper].min
        max = @input[lower..upper].max
        return min + max
      elsif sum > target
        lower += 1
      else
        upper += 1
      end
    end
    puts "could not find solution"
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
