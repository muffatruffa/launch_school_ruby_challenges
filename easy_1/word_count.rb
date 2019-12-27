class Phrase
  def initialize(phrase)
    @phrase = phrase
  end

  def word_count
    counts = Hash.new(0)
    @phrase.scan(/'?\b[\w']+\b'?/i) do |word|
    if word[0] == "'" && word[word.size - 1] == "'"
      word = word[1..-2]
    end
      counts[word.downcase] += 1
    end
    counts
  end
end