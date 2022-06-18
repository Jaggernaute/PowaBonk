
require "mysql2"

env_file = "../../resources/.env"

open(env_file) do |f|
  f.each do |line|
    key, value = line.split("=")
    ENV[key] = value.strip
    puts "#{key} = #{ENV[key]}"
  end
end

client = Mysql2::Client.new(
  :host => ENV["HOST"],
  :username => ENV["USERNAME"],
  :password => ENV["PASSWORD"],
  :database => ENV["DBNAME"]
)

query = "select `derniere-res` from utilisateurs"

client.query(query).each { |row|
  puts row.inspect
}

