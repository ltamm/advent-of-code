# frozen_string_literal: true

class Solution
  def initialize(input)
    @rules = File.read(input)
  end

  def solve_first_part
    mem = ['shiny gold']
    cursor = 0

    until cursor == mem.length
      bag = mem[cursor]
      matches = @rules.scan(/^([\w\s]+) bags contain.*#{Regexp.quote(bag)}.*$/)
      matches.each do |match|
        container_bag = match.first
        mem << container_bag unless mem.include? container_bag
      end
      cursor += 1
    end

    cursor - 1
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
