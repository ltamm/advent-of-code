#!/usr/bin/ruby
# frozen_string_literal: true

class Solution
  def initialize(input)
    @input = input.split(',').map(&:to_i)
  end

  def solve_to_nth(nth)
    spoken_when = {}
    @input[0...@input.length - 1].each_with_index {|n,i| spoken_when[n] = i + 1}

    last_spoken = @input.last
    ((@input.length + 1)..nth).each do |turn|
      turn_last_spoken = spoken_when[last_spoken]
      if turn_last_spoken.nil?
        spoken_now = 0
      else
        spoken_now = turn - 1 - turn_last_spoken
      end
      spoken_when[last_spoken] = turn - 1
      last_spoken = spoken_now
    end
    last_spoken
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_to_nth(2020)
    puts '---Solving Part 2---'
    puts solve_to_nth(30000000)
  end
end

input = '6,19,0,5,7,13,1'
Solution.new(input).solve
