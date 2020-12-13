#!/usr/bin/ruby
# frozen_string_literal: true

class ShipNav
  def initialize
    @ship_location = [0, 0]
    @waypoint_orientation = [10, -1]
    @waypoint_location = [10, -1]
  end

  def execute(program)
    program.each do |opcode, arg|
      instr = instruction_set[opcode]
      instr.call(arg.to_i)
    end
    puts manhattan_distance
  end

  private

  def manhattan_distance
    @ship_location[0].abs + @ship_location[1].abs
  end

  def update_orientation
    @waypoint_orientation[0] = @waypoint_location[0] - @ship_location[0]
    @waypoint_orientation[1] = @waypoint_location[1] - @ship_location[1]
  end

  def reset_waypoint
    @waypoint_location[0] = @ship_location[0] + @waypoint_orientation[0]
    @waypoint_location[1] = @ship_location[1] + @waypoint_orientation[1]
  end

  # why didn't this work when I set it as a constant?
  # something to do with proc scope?
  def instruction_set
    {
      'N' => proc { |n|
        @waypoint_location[1] -= n
        update_orientation
      },
      'S' => proc { |n|
        @waypoint_location[1] += n
        update_orientation
      },
      'E' => proc { |n|
        @waypoint_location[0] += n
        update_orientation
      },
      'W' => proc { |n|
        @waypoint_location[0] -= n
        update_orientation
      },
      'L' => proc { |n|
        # just rotate in increments of 90
        while n.positive?
          way_x = @waypoint_location[0]
          way_y = @waypoint_location[1]
          ship_x = @ship_location[0]
          ship_y = @ship_location[1]
          @waypoint_location = [-1 * (ship_y - way_y) + ship_x, (ship_x - way_x) + ship_y]
          n -= 90
        end
        update_orientation
      },
      'R' => proc { |n|
        while n.positive?
          way_x = @waypoint_location[0]
          way_y = @waypoint_location[1]
          ship_x = @ship_location[0]
          ship_y = @ship_location[1]
          @waypoint_location = [(ship_y - way_y) + ship_x, -1 * (ship_x - way_x) + ship_y]
          n -= 90
        end
        update_orientation
      },
      'F' => proc { |n|
        @ship_location[0] += n * @waypoint_orientation[0]
        @ship_location[1] += n * @waypoint_orientation[1]
        reset_waypoint
      }
    }.freeze
  end
end

input_file = ARGV[0]
program = File.readlines(input_file).map { |str| str.strip.unpack('a1a*') }
ShipNav.new.execute(program)
