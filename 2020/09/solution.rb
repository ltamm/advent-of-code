# frozen_string_literal: true

class Solution
  def initialize(input)
    # Process input
    @input = File.readlines(input).map { |n| n.strip.to_i }
    @preamble_length = 25
  end

  def solve_first_part
    lower = 0
    upper = @preamble_length

    while upper < @input.length
      preamble = @input[lower...upper]
      num = @input[upper]
      pattern_found = false

      (0...@preamble_length).each do |n|
        diff = num - preamble[n]

        # super cheesy way of handling the case where
        # adding the number to itself sums to the 
        # target value
        tmp = preamble[n]
        preamble[n] = -1
        if preamble.include? diff
          pattern_found = true
          break
        end
        preamble[n] = tmp
      end

      unless pattern_found
        @invalid_index = upper
        break
      else
        lower += 1
        upper += 1
      end
    end
    if @invalid_index.nil?
      error()
    else
      return @input[@invalid_index]
    end
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
    error()
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end

  private

  def error
    "No solution found :("
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
