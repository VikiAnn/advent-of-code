class CargoCrane
  attr_reader :stacks

  def initialize(input)
    @lines = input.split("\n")
    @stacks = parse_stacks(@lines)
  end

  def top_crates
    stacks.map { |s| s[0][1] }.join
  end

  def perform_operation!(lines = nil)
    instructions = lines ? parse_instructions(lines) : parse_instructions(@lines)
    instructions.each do |inst|
      puts "performing operation: move #{inst[:quantity]} from #{inst[:origin_stack]} to #{inst[:destination_stack]}"
      inst[:quantity].times do
        crate = @stacks[inst[:origin_stack] - 1].shift
        @stacks[inst[:destination_stack] - 1].prepend(crate)
      end
    end
  end
  
  private

  def parse_instructions(lines)
    instructions = lines.select { |line| line.start_with? 'move' }
    instructions.map(&:split).map do |inst|
      {
        quantity: inst[1].to_i,
        origin_stack: inst[3].to_i,
        destination_stack: inst[5].to_i
      }
    end
  end

  def parse_stacks(lines)
    rows = parse_rows(lines)
    
    loading_stacks = []
    rows.each do |row|
      row.each_with_index do |slot, i|
        loading_stacks[i] ||= []
        loading_stacks[i] << slot if slot.strip.length > 0
      end
    end
    loading_stacks
  end

  def parse_rows(lines)
    crate_rows = lines.select { |l| l.strip.start_with? '[' }
    rows = []
    crate_rows.each_with_index do |row, i|
      rows[i] ||= []
      row.each_char.each_slice(4) do |slot|
        rows[i] << slot[0..2].join
      end
    end
    rows
  end
end

require 'minitest/autorun'

class CargoCraneTest < Minitest::Test
  def setup
    @input = <<~CRATES
          [D]    
      [N] [C]    
      [Z] [M] [P]
      1   2   3 

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
    CRATES
  end

  def test_it_can_parse_correct_number_of_stacks_from_input
    cargo_crane = CargoCrane.new(@input)

    assert_equal(3, cargo_crane.stacks.count)
  end

  def test_each_stack_consists_of_correct_crates
    cargo_crane = CargoCrane.new(@input)

    expected_stacks = [['[N]', '[Z]'], ['[D]', '[C]', '[M]'], ['[P]']]
    assert_equal(expected_stacks, cargo_crane.stacks)
  end
  
  def test_it_can_create_message_from_top_crate_in_each_stack
    cargo_crane = CargoCrane.new(@input)
    
    assert_equal('NDP', cargo_crane.top_crates)
  end
  
  def test_it_can_perform_operations_from_original_instructions
    cargo_crane = CargoCrane.new(@input)
    cargo_crane.perform_operation!
    
    expected_stacks = [['[C]'], ['[M]'], ['[Z]', '[N]', '[D]', '[P]']]
    assert_equal(expected_stacks, cargo_crane.stacks)
  end
  
  def test_it_can_create_message_from_top_crate_after_performing_operations
    cargo_crane = CargoCrane.new(@input)
    cargo_crane.perform_operation!
    
    assert_equal('CMZ', cargo_crane.top_crates)
  end
  
  def test_it_can_follow_new_instructions
    cargo_crane = CargoCrane.new(@input)
    new_instructions = ['move 1 from 3 to 1', 'move 1 from 2 to 3']
    cargo_crane.perform_operation!(new_instructions)

    expected_stacks = [['[P]', '[N]', '[Z]'], ['[C]', '[M]'], ['[D]']]
    assert_equal(expected_stacks, cargo_crane.stacks)
  end
end

cargo_crane = CargoCrane.new(File.read('supply_stacks.txt'))
puts "Stacks before performing operations: "
cargo_crane.stacks.each_with_index do |stack, i|
  puts "Stack ##{i + 1}:"
  puts stack
end
puts "Top crates before operations: #{cargo_crane.top_crates}"
cargo_crane.perform_operation!
puts "Stacks after performing operations: "
cargo_crane.stacks.each_with_index do |stack, i|
  puts "Stack ##{i + 1}:"
  puts stack
end
puts "Top crates after operations: #{cargo_crane.top_crates}"