require 'yaml'
require './wordplay'
require './learner'

class ChatterBot
  attr_reader :name

  def initialize(options)
    @name = options[:name] || "PhilipBaby"
    @learner = Learner.new
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
    sentence = best_sentence(prepared_input)
    if dictionary_matches(sentence).empty? && @learner.get_response(sentence).empty? && !@learner.waiting
      @learner.add_unknown_sentence(sentence)
    end
    @learner.give_response(sentence) if @learner.waiting
    responses = possible_responses(sentence)
    if rand < 0.2 && !@learner.get_unknown_sentence.nil?
      @learner.get_unknown_sentence
    else
      responses.sample.gsub(/\[name\]/, @name)
    end
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

  def dictionary_matches(sentence)
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
    responses
  end

  def possible_responses(sentence)
    responses = dictionary_matches(sentence) || []
    if responses.empty? 
      if @learner.get_response(sentence).empty?
        responses << @data[:responses][:default]
      else
        responses << @learner.get_response(sentence)
      end
    end

    responses.flatten
  end
end
