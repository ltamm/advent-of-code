# frozen_string_literal: true

class Solution
  def initialize(input)
    @groups = []
    File.foreach(input, "\n\n") { |group| @groups << group.split("\n") }
  end

  def solve_first_part
    # Just for fun, throwback to the old Racket days
    @groups.inject(0) { |sum, group| sum + get_group_union(group) }
  end

  def solve_second_part
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end

  private

  def get_group_union(group)
    mask = 0
    group.each do |response|
      response_bin = '0' * 26
      response.split('').each do |c|
        response_bin[c.ord - 97] = '1'
      end
      mask |= response_bin.to_i(2)
    end
    mask.to_s(2).count('1')
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
