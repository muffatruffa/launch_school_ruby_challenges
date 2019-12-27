require 'minitest/autorun'
require 'minitest/pride'

require_relative 'odd_words'

# chracters can be: letters, spaces, point.
# words are one to 20 consecutive letters.
# Input text: One or more words, separeted by one or more spaces. It can ends with zero or more
# spaces and a point.

# Reading from left to right, print odd words in sentence (first word is at zero, even) in reverse order,
# words has to be separeted by a single space, last word is terminated by a point

class TestOdd_words < Minitest::Test
  def test_empty_sentence
    assert_equal '', OddWords.new('').reverse_odd
  end
  
  def test_dot
    assert_equal '.', OddWords.new('.').reverse_odd
  end

  def test_dot_space
    assert_equal '.', OddWords.new('  .').reverse_odd
  end
  
  def test_1_word
    assert_equal 'oneword.', OddWords.new('oneword.').reverse_odd
    assert_equal 'oneword.', OddWords.new('oneword  .').reverse_odd
  end

  def test_2_words_sinlge_space
    assert_equal 'one owt.', OddWords.new('one two.').reverse_odd
  end

  def test_2_words_ending_with_many_spaces
    assert_equal 'one owt.', OddWords.new('one two  .').reverse_odd
  end

  def test_2_words_many_spaces_between_them
    assert_equal 'one owt.', OddWords.new('one   two .').reverse_odd
  end
  
  def test_3_words
    assert_equal 'one owt three.', OddWords.new('one   two three  .').reverse_odd
  end
end