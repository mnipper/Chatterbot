require 'yaml'

bot_data = {
  :presubs => [
    ["dont", "don't"],
    ["youre", "you're"],
    ["love", "like"]
  ],

  :responses => {
    :default => [
                  "Wrong again.",
                  "I don't understand.",
                  "What?"
                ],
    :greeting => ["Hello everyone."],
    :farewell => ["l8r h8rs"],
    'hello'   => [
                  "Howdy.",
                  "k33p h8n"
                 ],
    'i like *' => [
                    "I don't care about *.",
                    "Wow! * is incredible!",
                  ]
  }
}

puts bot_data.to_yaml

f = File.open(ARGV.first || 'bot_data', "w")
f.puts bot_data.to_yaml
f.close
