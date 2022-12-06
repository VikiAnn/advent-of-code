class ElfTeam
  attr_reader :first_elf, :second_elf
  
  def initialize(raw_assignments)
    assignments = raw_assignments.split(",")
    @first_elf = assignment(assignments.first)
    @second_elf = assignment(assignments.last)
  end
  
  def totally_overlaps?
    first_elf.cover?(second_elf) || second_elf.cover?(first_elf)
  end

  def any_overlap?
    contains_range?(first_elf, second_elf) || contains_range?(second_elf, first_elf)
  end
  
  private
  
  def assignment(raw_assignment)
    first, last = raw_assignment.split("-").map(&:to_i)
    first..last
  end

  def contains_range?(first, second)
    first.include?(second.first) || first.include?(second.last)
  end
end

require 'minitest/autorun'

class ElfTeamTest < MiniTest::Test
  def test_it_can_identify_first_elf_assignment
    assignments_input = "2-4,6-8"
    elf_team = ElfTeam.new(assignments_input)
    
    assert_equal(2..4, elf_team.first_elf)
  end
  
  def test_it_can_identify_second_elf_assignment
    assignments_input = "2-4,6-8"
    elf_team = ElfTeam.new(assignments_input)
    
    assert_equal(6..8, elf_team.second_elf)
  end
  
  def test_it_can_identify_when_assignment_does_not_totally_overlap_with_another
    assignments_input = "2-4,6-8"
    elf_team = ElfTeam.new(assignments_input)
    
    refute(elf_team.totally_overlaps?)
  end

  def test_it_can_identify_when_assignment_totally_overlaps_with_another
    assignments_input = "2-8,4-6"
    elf_team = ElfTeam.new(assignments_input)
    
    assert(elf_team.totally_overlaps?)
  end

  def test_it_can_identify_when_assignments_do_not_overlap_at_all
    assignments_input = "2-4,6-8"
    elf_team = ElfTeam.new(assignments_input)
    
    refute(elf_team.any_overlap?)
  end

  def test_it_can_identify_when_assignment_overlaps_with_another
    assignments_input = "2-6,6-8"
    elf_team = ElfTeam.new(assignments_input)
    
    assert(elf_team.any_overlap?)
  end
end

assignments_input = "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"
assignments = assignments_input.split("\n").map do |raw_assignment|
  ElfTeam.new(raw_assignment)
end
full_overlap_count = assignments.count { |team| team.totally_overlaps? }
puts "There are #{full_overlap_count} elf teams with fully overlapping assignments"
overlap_count = assignments.count { |team| team.any_overlap? }
puts "There are #{overlap_count} elf teams with overlapping assignments"

assignments_input = File.read("elf_team_assignments.txt")
assignments = assignments_input.split("\n").map do |raw_assignment|
  ElfTeam.new(raw_assignment)
end
overlap_count = assignments.count { |team| team.totally_overlaps? }
puts "There are #{overlap_count} elf teams with fully overlapping assignments"
overlap_count = assignments.count { |team| team.any_overlap? }
puts "There are #{overlap_count} elf teams with overlapping assignments"
