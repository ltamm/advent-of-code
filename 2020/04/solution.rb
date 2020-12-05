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
      REQUIRED_FIELDS.each do |field|
        if not passport.key?(field) and field != 'cid'
          valid = false
          break
        end
      end
      count += 1 if valid
    end
    
    return count
  end

  def solve_second_part
    count = 0

    @passports.each do |passport|
      valid = true
      REQUIRED_FIELDS.each do |field|
        
        # Still invalid if required field is not present
        if not passport.key?(field) and field != 'cid'
          valid = false
          break
        end

        case field
          when 'byr'
            value = passport['byr']
            valid = valid && validate_num_range(1920, 2002, value)
          when 'iyr'
            value = passport['iyr']
            valid = valid && validate_num_range(2010, 2020, value)
          when 'eyr'
            value = passport['eyr']
            valid = valid && validate_num_range(2020, 2030, value)
          when 'hgt'
            value = passport['hgt']
            num, unit = value.scan(/(\d+)([a-z]+)/).first
            if unit == "cm"
              valid = valid && validate_num_range(150, 193, num)
            else
              valid = valid && validate_num_range(59, 76, num)
            end
          when 'hcl'
            value = passport['hcl']
            valid = valid && (value =~ /#[a-f0-9]{6}/)
          when 'ecl'
            value = passport['ecl']
            candidates = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
            valid = valid && candidates.include?(value)
          when 'pid'
            value = passport['pid']
            valid = valid && (value.length == 9) && (value =~ /\d{9}$/)
        end
      end
      count += 1 if valid
    end

    return count
  end

  def solve
    puts "---Solving Part 1---"
    puts solve_first_part
    puts "---Solving Part 2---"
    puts solve_second_part
  end

  private

  def validate_num_range(min, max, given)
    return given.to_i >= min && given.to_i <= max
  end

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