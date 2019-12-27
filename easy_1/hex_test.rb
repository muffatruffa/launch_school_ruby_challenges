require 'minitest/autorun'
require 'minitest/pride'

require_relative 'trinary'

class HEXTest < Minitest::Test
  def test_1_is_decimal_1
    assert_equal 1, Hex.new('1').to_decimal
  end

  def test_f_is_decimal_15
    assert_equal 15, Hex.new('f').to_decimal
  end

  def test_10_is_decimal_16
    assert_equal 16, Hex.new('10').to_decimal
  end

  def test_b_is_decimal_11
    assert_equal 11, Hex.new('b').to_decimal
  end

  def test_130_is_decimal_304
    # skip
    assert_equal 304, Hex.new('130').to_decimal
  end

  def test_7ff_is_decimal_2047
    # skip
    assert_equal 2047, Hex.new('7ff').to_decimal
  end

  def test_53977_is_decimal_342391
    # skip
    assert_equal 342_391, Hex.new('53977').to_decimal
  end

  def test_invalid_is_decimal_0
    # skip
    assert_equal 0, Hex.new('carrot').to_decimal
  end
end