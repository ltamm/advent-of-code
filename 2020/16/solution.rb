#!/usr/bin/ruby
# frozen_string_literal: true

class TicketSniffer
  attr_reader :field_checks

  def initialize(fields)
    # Turn field inputs into validity checks
    @field_checks = {}
    fields.split("\n").each do |field|
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
    solution_space = {}
    (0...fields.length).each do |position|
      val = []
      fields.each {|f| val << f}
      solution_space[position] = val
    end

    solved = []
    while solved.length < fields.length
      # iterate through tickets
      nearby_tickets.each do |ticket|
        # iterate through numbers in ticket
        ticket.split(',').map(&:to_i).each_with_index do |value, i|
          # if that position has not yet been solved
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

  # Returns a list of values that are invalid for any field
  # in the provided ticket
  def scan_ticket(ticket)
    invalid_values = []
    ticket.split(',').map(&:to_i).each do |val|
      is_valid = false
      field_checks.each_value do |check|
        is_valid ||= check.call(val)
      end
      invalid_values << val unless is_valid
    end
    invalid_values
  end
end

fields = %{\
departure location: 49-920 or 932-950
departure station: 28-106 or 130-969
departure platform: 47-633 or 646-950
departure track: 41-839 or 851-967
departure date: 30-71 or 88-966
departure time: 38-532 or 549-953
arrival location: 38-326 or 341-968
arrival station: 27-809 or 834-960
arrival platform: 29-314 or 322-949
arrival track: 26-358 or 368-966
class: 34-647 or 667-951
duration: 39-771 or 785-958
price: 43-275 or 286-960
route: 28-235 or 260-949
row: 48-373 or 392-962
seat: 35-147 or 172-953
train: 37-861 or 885-961
type: 38-473 or 483-961
wagon: 49-221 or 228-973
zone: 46-293 or 307-967
}
my_ticket = '101,179,193,103,53,89,181,139,137,97,61,71,197,59,67,173,199,211,191,131'
nearby_tickets = File.readlines('input').map(&:strip)

sniffer = TicketSniffer.new(fields)
invalid_tickets = sniffer.error_scan(nearby_tickets)

puts "Part 1: #{invalid_tickets.map(&:last).flatten.sum}"

# Remove invalid tickets
invalid_tickets.map(&:first).each { |t| nearby_tickets.delete(t) }

ordering = sniffer.deduce_field_order(nearby_tickets)
departure_indices = ordering.find_all {|k,v| k.start_with? "departure" }.to_h.values
# use the ordering to find the solution
ticket = my_ticket.split(',').map(&:to_i)
solution = 1
departure_indices.each do |i|
  solution *= ticket[i]
end

puts "Part 2: #{solution}"
