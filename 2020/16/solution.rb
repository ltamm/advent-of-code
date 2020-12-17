#!/usr/bin/ruby
# frozen_string_literal: true

class TicketSniffer
  attr_reader :field_checks

  def initialize(fields)
    # Turn field inputs into validity checks
    @field_checks = {}
    fields.each do |field|
      name, ranges = process_fields(field)
      @field_checks[name] = proc { |n| (n >= ranges[0] && n <= ranges[1]) || (n >= ranges[2] && n <= ranges[3]) }
    end
  end

  # Returns a list of the following pairings:
  #   [invalid ticket, [list of invalid values]]
  def error_scan(nearby_tickets)
    invalid_tickets = []
    nearby_tickets.each do |ticket|
      invalid_values = scan_ticket(ticket)
      invalid_tickets << [ticket, invalid_values] unless invalid_values.empty?
    end
    invalid_tickets
  end

  def deduce_field_order(nearby_tickets)
    fields = field_checks.keys
    solution_space = initialize_solution_space(fields)

    solved = []
    while solved.length < fields.length
      # iterate through tickets
      nearby_tickets.each do |ticket|
        # iterate through numbers in ticket
        ticket.each_with_index do |value, i|
          # only continue if that position has not yet been solved
          next if solved.include? i

          # iterate through the remaining possible fields
          possible_fields = solution_space[i]
          # if there is only one possible field, it is a new
          # solution - otherwise it would have been caught in the
          # in the solved collection
          if possible_fields.length == 1
            solved << i
            solved_field = possible_fields[0]
            # delete this field from all the other positions
            solution_space.each do |position, candidates|
              candidates.delete(solved_field) unless position == i
            end
            next
          end
          possible_fields.each do |field|
            next if field_checks[field].call(value)

            # CHECK FAILED - ELIMINATE!
            solution_space[i].delete(field)
          end
        end
      end
    end
    # reverse solution space so that the field is 
    # queried for the position in the ticket
    # assumes a succesful solve with a 1 - 1 mapping
    solution_space.sort.map { |k, v| [v[0], k] }.to_h
  end

  private

  # sets up the solution space for order
  # deduction
  #
  # Solution space begins as a hash mapping
  # each position to possible candidates (begins
  # with all candidates in all positions)
  def initialize_solution_space(fields)
    solution_space = {}
    (0...fields.length).each do |position|
      val = []
      fields.each { |f| val << f }
      solution_space[position] = val
    end
    solution_space
  end

  # Input: fields in raw input form
  #   e.g. 'class: 0-1 or 4-19'
  # Output:
  #   [field_name, array_of_range_values]
  #   where 'array_of_range_values' is a 4-element
  #   array capturing two inclusive value ranges
  #   (the first two elements consist of a range, as do
  #    the final two elements)
  #   Not very flexible, but works for the puzzle input :)
  def process_fields(field)
    name, range1, range2 = field.scan(/^([\w\s]+): (\d+-\d+) or (\d+-\d+)/).first
    ranges = []
    [range1, range2].each do |range|
      ranges += range.split('-').map(&:to_i)
    end
    [name, ranges]
  end

  # For a given ticket
  #   returns a list of the values printed on that ticket that
  #   do not satisfy the constraints of any field
  # a non-empty return value means the ticket is no good!
  def scan_ticket(ticket)
    invalid_values = []
    ticket.each do |val|
      is_valid = false
      field_checks.each_value do |check|
        is_valid ||= check.call(val)
      end
      invalid_values << val unless is_valid
    end
    invalid_values
  end
end

class Solution
  def initialize(input)
    # time for some hacky file processing
    raw_input = File.read(input).split("\n\n")
    @fields = raw_input[0].split("\n").map(&:strip)
    @my_ticket = raw_input[1].split("\n")[1].split(',').map(&:to_i)
    @nearby_tickets = raw_input[2].split("\n")[1..-1].map { |ticket| ticket.split(',').map(&:to_i) }
    @sniffer = TicketSniffer.new(@fields)
  end

  def solve
    puts '---Solving Part 1---'
    invalid_tickets = @sniffer.error_scan(@nearby_tickets)
    puts invalid_tickets.map(&:last).flatten.sum

    puts '---Solving Part 2---'
    # Remove invalid tickets
    invalid_tickets.map(&:first).each { |t| @nearby_tickets.delete(t) }
    ordering = @sniffer.deduce_field_order(@nearby_tickets)

    # extract the indices of fields that begin with 'departure'
    departure_indices = ordering.find_all { |k, _| k.start_with? 'departure' }.to_h.values

    # multiply all the departure values together
    solution = departure_indices.inject(1) { |product, i| product * @my_ticket[i] }
    puts solution
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
