require 'faker'

open('fichier_de_noms', 'w') { |f| 1000.times { f << Faker::Name.name + "\n" } }
