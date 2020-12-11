# frozen_string_literal: true

class Solution
  def initialize(input)
    @adapters = File.readlines(input).map { |j| j.to_i }
  end

  def solve_first_part
    chain = @adapters.sort!

    dist = [0, 0, 0]
    dist[chain[0] - 1] += 1
    (1...chain.length).each do |i|
      diff =  chain[i] - chain[i-1]
      dist[diff-1] += 1   
    end
    dist[0] * (dist[2] + 1)
  end

  def solve_second_part
    chain = @adapters.unshift 0
    chain.sort_by! { |a| -a }

    max = chain.shift
    memo = {max => 1}

    chain.each do |joltage|
      total = 0
      (1..3).each do |n|
        connector = joltage + n
        if connector <= max && memo.include?(connector)
          total += memo[connector]
        end
      end
      memo[joltage] = total
    end
    memo[0]
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
