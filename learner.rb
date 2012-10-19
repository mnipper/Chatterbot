class Learner
  attr_reader :sentences, :waiting

  def initialize
    @sentences = Hash.new{|h, k| h[k] = []}
    @waiting = false
  end

  def give_response(response)
    @sentences[@last_unknown_sentence] << response
    @waiting = false
  end

  def get_response(sentence)
    @sentences[sentence]
  end

  def get_unknown_sentence
    @waiting = true
    @last_unknown_sentence = @sentences.key([])
    @last_unknown_sentence
  end

  def add_unknown_sentence(sentence)
    @sentences[sentence] = []
  end
end
