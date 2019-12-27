require 'minitest/autorun'
require 'minitest/pride'

require_relative 'palindrome'

class PalindromeTest < Minitest::Test
  def test_one_character_is_palindorome
    assert Palindrome.new('a').palindrome?
  end

  def test_detect_two_character_palindrome
    assert Palindrome.new('aA').palindrome?
  end

  def test_detect_two_character_non_palindrome
    refute Palindrome.new('aB').palindrome?
  end

  def test_detect_three_character_palindrome
    assert Palindrome.new('aBA').palindrome?
  end

  def test_detect_four_character_palindrome
    assert Palindrome.new('aCcA').palindrome?
  end

  def test_detect_three_character_non_palindrome
    refute Palindrome.new('aBf').palindrome?
  end

  def test_detect_four_character_non_palindrome
    refute Palindrome.new('aChA').palindrome?
  end

  def test_detect_four_character_palindrome_with_no_alpha
    assert Palindrome.new('1aCc$A').palindrome?
  end
end