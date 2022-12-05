class ElvenLuggageHandler
  ITEM_TYPES = '.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  
  def rucksacks(raw_luggage)
    raw_luggage.split("\n")
  end
  
  def compartments(rucksack)
    split_spot = rucksack.length / 2
    
    [rucksack[0..(split_spot - 1)], rucksack[split_spot..-1]]
  end

  def priority(rucksack)
    compartment1, compartment2 = compartments(rucksack)
    
    common_items = rucksack.each_char.select do |item|
      compartment1.include?(item) && compartment2.include?(item)
    end.uniq
    
    common_items.map { |e| ITEM_TYPES.index(e) }.sum
  end
  
  def priorities_sum(luggage)
    rucksacks(luggage).sum { |rucksack| priority(rucksack) }
  end

  def badge_item(group)
    raise ArgumentError, "Group must be an array of 3 strings" unless group.length == 3

    ITEM_TYPES.each_char.find do |item|
      group.all? { |rucksack| rucksack.include?(item) }
    end
  end

  def badge_item_scores(luggage)
    rucksacks(luggage).each_slice(3).sum do |group|
      ITEM_TYPES.index(badge_item(group))
    end
  end
end

require 'minitest/autorun'

class ElvenLuggageHandlerTest < Minitest::Test
  def setup
    @handler = ElvenLuggageHandler.new
    @test_luggage = "vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw"
  end 
  
  def test_it_can_split_rucksacks_from_raw_luggage
    rucksacks = @handler.rucksacks(@test_luggage)
    
    assert_equal(6, rucksacks.length)
  end
  
  def test_each_rucksack_has_two_compartments
    rucksacks = @handler.rucksacks(@test_luggage)
    
    rucksacks.each do |rucksack|
      assert_equal(2, @handler.compartments(rucksack).length)
    end
  end
  
  def test_rucksack_compartments_are_equal_in_length
    rucksacks = @handler.rucksacks(@test_luggage)
    
    rucksacks.each do |rucksack|
      assert_equal(rucksack[0].length, rucksack[1].length)
    end
  end
  
  def test_handler_can_evaluate_a_single_rucksack_compartments
    rucksack = @test_luggage.split("\n").first
    rucksack_compartments = @handler.compartments(rucksack)
    
    assert_equal(2, rucksack_compartments.length)
    assert_equal(rucksack_compartments[0].length, rucksack_compartments[1].length)
  end
  
  def test_it_can_prioritize_a_rucksack
    rucksack = @test_luggage.split("\n").first
    
    assert_equal(16, @handler.priority(rucksack))
  end
  
  def test_it_can_sum_priorities_for_entire_luggage_collection
    priorities_sum = @handler.priorities_sum(@test_luggage)
    
    assert_equal(157, priorities_sum)
  end

  def test_it_can_identify_badge_items
    group1 = @test_luggage.split("\n")[0..2]
    group2 = @test_luggage.split("\n")[3..-1]

    assert_equal('r', @handler.badge_item(group1))
    assert_equal('Z', @handler.badge_item(group2))
  end

  def test_it_can_sum_badge_item_scores
    badge_item_scores = @handler.badge_item_scores(@test_luggage)
    
    assert_equal(70, badge_item_scores)
  end
end

luggage = File.read('elven_luggage.txt')
handler = ElvenLuggageHandler.new
puts "Total priorities for luggage: #{handler.priorities_sum(luggage)}"

puts "Item badges are: "
puts handler.rucksacks(luggage).each_slice(3).map { |s| handler.badge_item(s) }

puts "Item badge total: #{handler.badge_item_scores(luggage)}"
