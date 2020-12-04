class Solution
  
  def initialize(input)
    @input  = input.map { |s| s.strip }
    @width  = @input[0].length
    @height = @input.length
  end
  
  def solve_first_part
    return count_trees_on_slope(0, 0)
  end

  def solve_second_part
    slopes = [
      [1, 1],
      [3, 1],
      [5, 1],
      [7, 1],
      [1, 2]
    ]

    total = 1
    for slope in slopes
      total *= count_trees_on_slope(0, 0, slope)
    end

    return total

  end

  def solve
    puts "---Solving Part 1---"
    puts solve_first_part
    puts "---Solving Part 2---"
    puts solve_second_part
  end

  private
  def count_trees_on_slope(x, y, slope=[3, 1])
    return 0 if y >= @height

    x = x % @width
    
    count = count_trees_on_slope(x + slope[0], y + slope[1], slope)
    if @input[y][x] == '#'
      return 1 + count
    else
      return count
    end
  end
end

input_file = ARGV[0]
input = File.readlines(input_file)
Solution.new(input).solve
