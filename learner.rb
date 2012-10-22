require 'yaml'

class Learner
  attr_reader :sentences, :waiting

  def initialize
    @waiting = false
    begin
      @sentences = YAML.load(File.read("learn_data")) || Hash.new{|h, k| h[k] = []}
    rescue
      raise "Can't load learn data"
    end
  end

  def give_response(response)
    @sentences[@last_unknown_sentence] << response.strip
    write_to_yaml @sentences
    @waiting = false
  end

  def get_response(sentence)
    @sentences[sentence.strip] || ''
  end

  def get_unknown_sentence
    @waiting = true
    @last_unknown_sentence = @sentences.key([])
    @last_unknown_sentence
  end

  def add_unknown_sentence(sentence)
    @sentences[sentence.strip] = []
  end

  private

  def write_to_yaml(h)
    f = File.open('learn_data','w')
    f.puts h.to_yaml
    f.close
  end
end
