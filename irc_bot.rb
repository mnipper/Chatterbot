require 'cinch'
require './creds.rb'
require './chatterbot'

chatterbot = ChatterBot.new(:data_file => 'bot_data')

bot = Cinch::Bot.new do
  configure do |c|
    c.server = Creds.server
    c.password = Creds.password
    c.nick = Creds.nick
    c.channels = Creds.channels
  end

  on :message do |m|
    m.reply chatterbot.response_to(m.message) if m.message =~ /^\$/ || rand < 0.06
  end

end

bot.start
