class Translator
  def initialize(word)
    @word = word
  end

  def translate
    raise "#{self.class} should implement #translate"
  end
end

class VowelSound < Translator
  def translate
    "#{@word}ay"
  end
end

class ConsonantSound < Translator
  def translate
    "#{@word[1..-1]}#{@word[0]}ay"
  end
end

class TwoConsonantCluster < Translator
  def translate
    "#{@word[2..-1]}#{@word[0..1]}ay"
  end
end

class ThreeConsonantCluster < Translator
  def translate
    "#{@word[3..-1]}#{@word[0..2]}ay"
  end
end

class PigLatin
  attr_reader :translators
  
  def initialize(words)
    @words = words.split(' ')
    @translators = translators_for_words
  end

  def self.translate(words)
    new(words).translators.map do |translator|
      translator.translate
    end.join(' ')
  end

  private

  def translators_for_words
    @words.map do |word|
      translator = case word[0..2]
      when /\A(?!qu)[^aeiuo][aeiou].\z/i then ConsonantSound
      when /\Ach.\z|\Ath[^r]\z|\Aqu.\z/i then TwoConsonantCluster
      when /\A[^aeiou]qu\z|\Athr\z|\Asch\z/i then ThreeConsonantCluster
      else VowelSound
      end
      translator.new(word)
    end
  end
end

# class PigLatin
#   def self.translate(phrase)
#     phrase.split(' ').map do |word|
#       translate_word(word)
#     end.join(' ')
#   end

#   def self.translate_word(word)
#     if begins_with_vowel_sound?(word)
#       word + 'ay'
#     else
#       consonant_sound, the_rest_of_word = parse_for_consonant(word)
#       the_rest_of_word + consonant_sound + 'ay'
#     end
#   end

#   def self.begins_with_vowel_sound?(word)
#     word.match(/\A[aeiou]|[xy][^aeiou]/)
#   end

#   def self.parse_for_consonant(word)
#     consonant_split = /\A([^aeiou]*qu|[^aeiou]+)([aeiou].*)\z/.match(word)
#     [consonant_split[1], consonant_split[2]]
#   end
# end

if $PROGRAM_NAME == __FILE__
  p PigLatin.translate('hello')
end