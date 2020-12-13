#!/usr/bin/ruby
# frozen_string_literal: true

class ShipNav
  def initialize
    @location = [0, 0]
    @heading = 90
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
    @location[0].abs + @location[1].abs
  end

  # why didn't this work when I set it as a constant?
  # something to do with proc scope?
  def instruction_set
    {
      'N' => proc { |n|
        @location[1] -= n
      },
      'S' => proc { |n|
        @location[1] += n
      },
      'E' => proc { |n|
        @location[0] += n
      },
      'W' => proc { |n|
        @location[0] -= n
      },
      'L' => proc { |n|
        @heading += (360 - n)
        @heading = @heading % 360 if @heading > 360
      },
      'R' => proc { |n|
        @heading += n
        @heading = @heading % 360 if @heading > 360
      },
      'F' => proc { |n|
        case @heading
        when 360
          @location[1] -= n
        when 90
          @location[0] += n
        when 180
          @location[1] += n
        when 270
          @location[0] -= n
        end
      }
    }.freeze
  end
end

input_file = ARGV[0]
program = File.readlines(input_file).map { |str| str.strip.unpack('a1a*') }
ShipNav.new.execute(program)
