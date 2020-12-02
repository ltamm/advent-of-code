class Solution
  
  def initialize(input)
    @input = input
  end
  
  def solve_first_part!
    count = 0
    
    for line in @input
      # assumption: all password chars are alphanumeric, lower case
      matches = line.scan(/(\d+)-(\d+)\s(.):\s([a-z]+)/).first
      min, max = matches.first(2).map { |n| n.to_i }
      char, password = matches.last(2)
      occurrences = password.count(char)

      if occurrences >= min and occurrences <= max 
        count +=1
      end
    end

    return count
  end

  def solve_second_part!
    count = 0

    for line in @input
      # assumption: all password chars are alphanumeric, lower case
      matches = line.scan(/(\d+)-(\d+)\s(.):\s([a-z]+)/).first
      positions = matches.first(2).map { |n| n.to_i - 1 } # subtracting because no index 0
      char, password = matches.last(2)

      candidates = []
      for position in positions
        candidates << password[position]
      end

      if candidates.count(char) == 1
        count += 1
      end
    end

    return count
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