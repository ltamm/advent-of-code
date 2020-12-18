#!/usr/bin/ruby
# frozen_string_literal: true

class ConwayCube
  attr_reader :x, :y, :z, :active

  def initialize(x:, y:, z:, active: false)
    @x = x
    @y = y
    @z = z
    @active = active
  end

  # returns true if this ConwayCube is adjacent
  # to another ConwayCube (true if all of their coordinates
  # differ by at most one
  def adjacent_to?(other)
    (x - other.x).abs <= 1 &&
      (y - other.y).abs <= 1 &&
      (z - other.z).abs <= 1 &&
      self != other
  end

  def swap_activity!
    @active = !active
    self
  end

  # Some overrides
  def to_s
    puts "<Position: x=#{x}, y=#{y}, z=#{z}. Active: #{active}>"
  end

  def ==(other)
    x == other.x &&
      y == other.y &&
      z == other.z
  end
end

class PocketDimension
  def initialize
    # initialize collection of cubes
    # initialize swap rules
  end

  def cycle!
    # for each cube
    # find neighbours
  end
end

c = ConwayCube.new(x: 2, y: 2, z: 3)
c1 = ConwayCube.new(x:1, y:2, z: 3)
