class Solution
  
  REQUIRED_FIELDS = [
    'byr',
    'iyr',
    'eyr',
    'hgt',
    'hcl',
    'ecl',
    'pid',
    'cid'
  ].freeze

  def initialize(input_file)
    @passports = []
    File.foreach(input_file, "\n\n") { |s| @passports << process(s.strip) }
  end
  
  def solve_first_part
    count = 0

    @passports.each do |passport|
      valid = true
      REQUIRED_FIELDS.each do |required_field|
        if not passport.key?(required_field) and required_field != 'cid'
          valid = false
          break
        end
      end
      count += 1 if valid
    end
    
    return count
  end

  def solve_second_part
  end

  def solve
    puts "---Solving Part 1---"
    puts solve_first_part
    puts "---Solving Part 2---"
    puts solve_second_part
  end

  private

  # returns an array of field,value pairs
  def process(password_entry)
    passport = {}
    password_entry.tr("\n", "\s").split("\s").each do |field|
      label, value = field.split(':')
      passport[label] = value
    end
    return passport
  end

end

input_file = ARGV[0]
Solution.new(input_file).solve