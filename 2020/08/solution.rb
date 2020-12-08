# frozen_string_literal: true

class Solution
  def initialize(input)
    @input = File.readlines(input)
  end

  def solve_first_part
    mem = [false] * @input.length
    cursor = 0
    acc = 0

    until mem[cursor]
      mem[cursor] = true
      instr = @input[cursor].strip
      op, arg = instr.scan(/(\w+) \+?(-?\d+)/).first

      case op
        when 'nop'
          cursor += 1
        when 'acc'
          acc += arg.to_i
          cursor += 1
        when 'jmp'
          cursor += arg.to_i
      end
    end
    acc
  end

  def solve_second_part
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
