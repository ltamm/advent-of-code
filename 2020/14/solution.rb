#!/usr/bin/ruby
# frozen_string_literal: true

class DecoderChip
  attr_reader :memory
  attr_accessor :mask

  def initialize
    @memory = {}
  end

  def write(address, value)
    # First we switch the Xs into 1s
    # and apply a bitwise AND operation between the
    # mask and the value.
    # This ensures that any 1 bits masked with an X are
    # carried forward (and maintaining that zeros in the mask
    # remain zeros)
    value &= mask.gsub('X', '1').to_i(2)

    # Next we switch the Xs into 0s
    # and apply a bitwise OR operation between the
    # mask and the value
    # This ensures that ones masking zeros surface as
    # ones
    value |= mask.gsub('X', '0').to_i(2)
    memory[address] = value
    value
  end
end

class DecoderChipV2 < DecoderChip
  def write(address, value)
    # turn all mask X's into 1s and apply a bitwise-OR operatation
    # between the mask and the address
    # this will make sure all the non-floating bits are properly
    # masked and fulfills the described properties of the mask
    address |= mask.gsub('X', '1').to_i(2)

    # put mask with least significant bits first
    # for ease of iteration
    little_endian_mask = @mask.split('').reverse
    addresses_to_write = [address]

    # Iterate over the bits in the mask
    # when we encounter an 'X', iterate over each
    # address we plan to write to and add a copy
    # of it with the bit masked by the X flipped
    little_endian_mask.each_with_index do |bit, i|
      next if bit != 'X'

      # store new addresses in a separate array to avoid an
      # infinite loop
      addresses_to_write += new_addresses_to_write(i, addresses_to_write)
    end

    addresses_to_write.each { |a| memory[a] = value }
  end

  private

  # Iterates through the existing write addresses,
  # and for each address adds a new write address
  # with bit 'i' swapped
  def new_addresses_to_write(i, existing_addresses)
    new_addresses = []
    existing_addresses.each do |address|
      address_bit_is_one = ((address >> i) % 2).odd?
      if address_bit_is_one
        # add an address with 2^i subtracted
        new_addresses << (address - 2**i)
      else
        # add an address with 2^i added
        new_addresses << (address + 2**i)
      end
    end
    new_addresses
  end
end

class Solution
  def initialize(input)
    # Process input
    @input = File.readlines(input)
  end

  def execute_program(decoder_chip)
    @input.each do |instruction|
      if instruction.start_with?('mask =')
        decoder_chip.mask = instruction.split('mask = ').last.strip
        next
      end
      address, value = instruction.scan(/mem\[(\d+)\] = (\d+)/).first.map(&:to_i)
      decoder_chip.write(address, value)
    end
    decoder_chip.memory.values.reduce(:+)
  end

  def solve_first_part
    dc = DecoderChip.new
    execute_program(dc)
  end

  def solve_second_part
    dc = DecoderChipV2.new
    execute_program(dc)
  end

  def solve
    puts '---Solving Part 1---'
    puts solve_first_part
    puts '---Solving Part 2---'
    puts solve_second_part
  end
end

input_file = ARGV[0]
Solution.new(input_file).solve
