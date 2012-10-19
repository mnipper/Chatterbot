require 'cinch'
require './creds'
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
    if m.message =~ /^\$/
      m.reply chatterbot.response_to(m.message[1..-1])
    else
      m.reply chatterbot.response_to(m.message) if rand < 0.06
    end
  end

end

bot.start
