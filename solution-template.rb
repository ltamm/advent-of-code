class Solution
  
  def initialize(input)
    @input = input
  end
  
  def solve_first_part!
  end

  def solve_second_part!
  end

  def solve!
    puts "---Solving Part 1---"
    puts solve_first_part!
    puts "---Solving Part 2---"
    puts solve_second_part!
  end
end

input_file = ARGV[0]
input = File.readlines(input_file)
Solution.new(input).solve!