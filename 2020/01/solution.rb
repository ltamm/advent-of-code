class Solution
  
  def initialize(input)
    @input = input
  end
  
  def solve!
    while not @input.empty?
      n = @input.shift
      @input.each do |m|
        difference = 2020 - n - m
        if @input.include? difference
          return difference * n * m
        end
      end
    end
    return -1
  end
end

input_file = ARGV[0]
input = File.readlines(input_file).map { |n| n.to_i }
puts Solution.new(input).solve!
