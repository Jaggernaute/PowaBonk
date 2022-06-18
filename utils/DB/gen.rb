require 'faker'

open('first_name_file', 'w') { |f| 1000.times { f << Faker::Name.first_name + "\n" } }
open('last_name_file', 'w') { |f| 1000.times { f << Faker::Name.last_name + "\n" } }
open('date_file', 'w') { |f| 1000.times {f << Faker::Date.between(from: Date.new(2021, 12, 1), to: Date.new(2021, 12, 8)).to_s + "\n" }}