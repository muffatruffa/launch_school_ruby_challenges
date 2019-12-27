# class Scrabble
#   POINTS = {
#     %w(A E I O U L N R S T ) => 1,
#     %w(D G) => 2,
#     %w(B C M P) => 3,
#     %w(F H V W Y) => 4,
#     %w(K) => 5,
#     %w(J X) => 8,
#     %w(Q Z) => 10
#   }

#   def initialize(word)
#     @word = word
#   end

#   def self.score(word)
#     new(word).score
#   end

#   def letter_point(letter)
#     POINTS.each do |(letters, score)|
#       return score if letters.include?(letter.upcase)
#     end
#   end

#   def score
#     return 0 unless @word
#     total = 0
#     @word.scan(/[a-zA-Z]/i) do |letter|
#       total += letter_point(letter)
#     end
#     total
#   end
# end

class Scrabble
  def initialize(word)
    @word = word
  end

  def self.score(word)
    new(word).score
  end

  def letter_point(letter)
    case letter
    when /[AEIOULNRST]/i then 1
    when /[DG]/i then 2
    when /[BCMP]/i then 3
    when /[FHVWY]/i then 4
    when /K/i then 5
    when /[JX]/i then 8
    when /[QZ]/i then 10
    else 0
    end
  end

  def score
    rec_scores = ->(word, total) do
      return total if word.nil? || word.empty?

      rec_scores.(word[1..-1], total + letter_point(word[0]))
    end

    rec_scores.(@word, 0)
  end
end
