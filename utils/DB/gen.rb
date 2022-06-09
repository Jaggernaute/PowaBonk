require 'faker'

open('first_name_file', 'w') { |f| 1000.times { f << Faker::Name.first_name + "\n" } }
open('last_name_file', 'w') { |f| 1000.times { f << Faker::Name.last_name + "\n" } }
