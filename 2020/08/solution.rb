# frozen_string_literal: true

class Solution
  def initialize(input)
    @input = File.readlines(input)
  end

  def solve_first_part
    run_program.last
  end

  def solve_second_part
    @input.each_with_index do |instr, i|
      if instr.include? 'nop'
        @input[i] = instr.gsub 'nop', 'jmp'
      elsif instr.include? 'jmp'
        @input[i] = instr.gsub 'jmp', 'nop'
      else
        next
      end
      res = run_program
      return res.last if res.first

      # Put the original instruction back
      @input[i] = instr
    end
    'No solution found :('
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end

  private

  def run_program
    mem = [false] * @input.length
    cursor = 0
    acc = 0
    completed = true
    until cursor == mem.length
      if mem[cursor]
        completed = false
        break
      end

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
    [completed, acc]
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
