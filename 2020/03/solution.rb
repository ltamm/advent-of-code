class Solution
  
  def initialize(input)
    @input = input.map { |s| s.strip }
    @width = @input[0].length
    @height = @input.length
  end
  
  def solve_first_part!
    return count_trees_on_slope(0, 0)
  end

  def solve_second_part!
  end

  def solve!
    puts "---Solving Part 1---"
    puts solve_first_part!
    puts "---Solving Part 2---"
    puts solve_second_part!
  end

  private
  def count_trees_on_slope(x, y)
    return 0 if y == @height

    x = x % @width

    if @input[y][x] == '#'
      return 1 + count_trees_on_slope(x + 3, y + 1)
    else
      return count_trees_on_slope(x + 3, y + 1)
    end
  end
end

input_file = ARGV[0]
input = File.readlines(input_file)
Solution.new(input).solve!
