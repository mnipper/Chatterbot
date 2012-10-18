require './chatterbot'

bot = ChatterBot.new(:data_file => 'bot_data')

puts bot.greeting

while input = gets and input.chomp != 'end'
  puts '>> ' + bot.response_to(input)
end

puts bot.farewell
