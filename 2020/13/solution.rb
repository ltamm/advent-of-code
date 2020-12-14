#!/usr/bin/ruby
# frozen_string_literal: true

def earliest_bus(etd, routes)
  # save earliest departure we encounter
  # as [route_no, next_departure]
  earliest_bus = []
  routes.each do |route|
    next if route == 'x'

    next_departure = next_departure(etd, route.to_i)
    if earliest_bus.empty? || next_departure < earliest_bus[1]
      earliest_bus = [route.to_i, next_departure]
    end
  end
  earliest_bus
end

def next_departure(floor, n)
  # get lowest multiple of n that is >= the given floor
  return n if (floor % n).zero?

  n * ((floor / n) + 1)
end

input_file = ARGV[0]
etd, routes = File.readlines(input_file).map(&:strip)
etd = etd.to_i
routes = routes.split(',')

# Part 1
earliest_bus = earliest_bus(etd, routes)
minutes_to_wait = earliest_bus[1] - etd
puts "Part 1: #{earliest_bus[0] * minutes_to_wait} minute wait"
