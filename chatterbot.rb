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

  def greeting
    random_response :greeting
  end

  def farewell
    random_response :farewell
  end

  def response_to(input)
    prepared_input = preprocess(input).downcase
  end

  private

  def random_response(key)
    @data[:responses][key].sample.gsub(/\[name\]/, @name)
  end

  def preprocess(input)
    perform_substitutions input
  end

  def perform_substitutions(input)
    @data[:presubs].each { |s| input.gsub!(s[0], s[1]) }
    input
  end
end
