require 'yaml'
require '../wordplay/wordplay'

class ChatterBot
  attr_reader :name

  def initialize(options)
    @name = options[:name] || "PhilipBaby"
    begin
      @data = YAML.load(File.read(options[:data_file]))
    rescue
      raise "Can't load bot data"
    end
  end
end
