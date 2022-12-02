require 'bundler/inline'

gemfile do 
  source 'https://rubygems.org'
  gem 'pry'
end

elven_snack_bundles= File.read('elves_snacks.txt').split("\n\n")
calorie_totals = elven_snack_bundles.map do |elf|
  elf.split("\n").map(&:to_i).sum
end

puts "The elf carrying the most calories has #{calorie_totals.max} calories total"
