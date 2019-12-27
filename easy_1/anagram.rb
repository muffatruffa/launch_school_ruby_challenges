class Anagram
  def initialize(word)
    @word = word
  end

  # def match(anagrams)
  #   sorted_anagrams = anagrams.map { |anagram| anagram.downcase.chars.sort.join }
  #   sorted_word = @word.downcase.chars.sort.join
  #   anagrams.select.with_index do |anagram, index|
  #     sorted_word == sorted_anagrams[index] &&
  #     anagrams[index].downcase != @word.downcase
  #   end
  # end

  def match(anagrams)
    anagrams.select do |anagram|
      anagram?(anagram)
    end
  end

  def anagram?(anagram)
    return false if @word.downcase == anagram.downcase

    same_size?(anagram) && same_character_count?(anagram)
  end

  def same_size?(anagram)
    @word.size == anagram.size
  end

  def same_character_count?(anagram)
    (0...@word.size).all? do|position|
      character = @word[position].downcase
      @word.downcase.count(character) == anagram.downcase.count(character)
    end
  end
end