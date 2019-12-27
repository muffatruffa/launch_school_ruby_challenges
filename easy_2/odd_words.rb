class OddWords
  attr_reader :sentence

  def initialize(sentence)
    @sentence = sentence
  end

  def reversed_at_odd
    sentence.split(/\s+/).map.with_index do |letters, index|
      match_data_word = letters.match(/([\w]+)\s*\.?/)
      next '' unless match_data_word
      if index.even?
        match_data_word[1]
      else
        match_data_word[1].reverse
      end
    end
  end

  # def reverse_odd
  #   return '' if sentence.empty?
  #   reversed_at_odd.join(' ').strip + '.'
  # end

  def reverse_odd
    is_in_word = true
    word_position = 0
    current = 0
    reversed = ''
    while current < sentence.size
      if /[a-zA-Z]/i =~ sentence[current]
        is_in_word = true
      else
        reversed << '.' if sentence[current] == '.'
        is_in_word = false
        if /[a-zA-Z]/i =~ sentence[current + 1]
          word_position += 1
          reversed << ' '
        end
      end

      if is_in_word
        if word_position.even?
          reversed << sentence[current]
        else
          last_word_letter = current
          while /[a-zA-Z]/i =~ sentence[last_word_letter]
            last_word_letter += 1
          end
          last_word_letter -= 1
          last_word_letter.downto(current) {|char_position| reversed << sentence[char_position]}
          current = last_word_letter
        end
      end
      current += 1
    end
    reversed
  end
end

if $PROGRAM_NAME == __FILE__
  s = OddWords.new('abc  dfg even.')
  p s.reverse_by_char
  point = OddWords.new('.')
  one = OddWords.new('one.')
  p point.reverse_by_char
  p one.reverse_by_char
end