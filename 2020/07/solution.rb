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
        outer_bag = match.first
        mem << outer_bag unless mem.include? outer_bag
      end
      cursor += 1
    end

    cursor - 1
  end

  def solve_second_part
    traverse_bag_wormhole('shiny gold') - 1
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end

  private

  def traverse_bag_wormhole(bag)
    # find the line describing the rule for this bag
    innards = @rules.scan(/#{Regexp.quote(bag)} bags contain ([\s\w,]+)\.$/).first[0]

    return 1 if innards == 'no other bags'

    total = 1
    innards.split(',').each do |innard|
      innard = innard.strip
      amt, desc = innard.scan(/(\d+) ([\w\s]+) bags?/).first
      total += amt.to_i * traverse_bag_wormhole(desc)
    end
    total
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
