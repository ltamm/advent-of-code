#!/usr/bin/ruby
# frozen_string_literal: true

class TicketScanner
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

# Test Data

fields = %{\
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50
}
my_ticket = '7,1,14'
nearby_tickets = File.readlines('test').map(&:strip)

# Actual Input

# fields = %{\
# departure location: 49-920 or 932-950
# departure station: 28-106 or 130-969
# departure platform: 47-633 or 646-950
# departure track: 41-839 or 851-967
# departure date: 30-71 or 88-966
# departure time: 38-532 or 549-953
# arrival location: 38-326 or 341-968
# arrival station: 27-809 or 834-960
# arrival platform: 29-314 or 322-949
# arrival track: 26-358 or 368-966
# class: 34-647 or 667-951
# duration: 39-771 or 785-958
# price: 43-275 or 286-960
# route: 28-235 or 260-949
# row: 48-373 or 392-962
# seat: 35-147 or 172-953
# train: 37-861 or 885-961
# type: 38-473 or 483-961
# wagon: 49-221 or 228-973
# zone: 46-293 or 307-967
# }
nearby_tickets = File.readlines('test').map(&:strip)
invalid_tickets = TicketScanner.new(fields).error_scan(nearby_tickets)

puts "Part 1: #{invalid_tickets.map(&:last).flatten.sum}"

# Remove invalid tickets
invalid_tickets.map(&:first).each { |t| nearby_tickets.delete(t) }
