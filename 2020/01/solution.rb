class Solution
  
  def initialize(input)
    @input = input
  end
  
  def solve!
    @input = @input.sort!

    for n in @input do
      # if this value was going to be part of the answer, we'd have found it already
      @input.delete(n)
      for m in @input do
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

starting = Time.now
puts Solution.new(input).solve!
ending = Time.now
elapsed = ending - starting
puts elapsed
