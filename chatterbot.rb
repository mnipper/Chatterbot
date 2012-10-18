require 'yaml'
require './wordplay'

class ChatterBot
  attr_reader :name

  def initialize(options)
    @name = options[:name] || "PhilipBaby"
    begin
      @data = YAML.load(File.read(options[:data_file]))
      @data[:responses][:learning] = []
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
    sentence = best_sentence(prepared_input)
    responses = possible_responses(sentence)
    responses.sample.gsub(/\[name\]/, @name)
  end

  private

  def random_response(key)
    @data[:responses][key].sample.gsub(/\[name\]/, @name)
  end

  def preprocess(input)
    perform_substitutions input
  end

  def perform_substitutions(input)
    @data[:presubs].each { |s| input.gsub!(/\bs[0]\b/, s[1]) }
    input
  end

  def best_sentence(input)
    hot_words = @data[:responses].keys.select do |k|
      k.class == String && k =~ /^\w+$/
    end

    WordPlay.best_sentence(input.sentences, hot_words)
  end

  def possible_responses(sentence)
    responses = []

    @data[:responses].keys.each do |pattern|
      next unless pattern.is_a?(String)

      if sentence.match('\b' + pattern.gsub(/\*/, '') + '\b')
        if pattern.include?('*')
          responses << @data[:responses][pattern].collect do |phrase|
            matching_section = sentence.sub(/^.*#{pattern}\s+/, '')
            phrase.sub('*', WordPlay.switch_pronouns(matching_section))
          end
        else
          responses << @data[:responses][pattern]
        end
      end
    end

    if responses.empty?
      responses << @data[:responses][:default]
      #responses << @data[:responses][:learning][:statement]
      #@data[:responses][:learning][:statement] << sentence
    end
    responses.flatten
  end
end
