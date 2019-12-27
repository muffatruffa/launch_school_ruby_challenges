class AnyBase
  attr_reader :base, :string_digits

  def initialize(string_digits)
    @string_digits = string_digits
    @base = numeral_system_base
  end

  def to_decimal
    return 0 unless valid?
    max_power = numeric_digits.size - 1

    numeric_digits.each_index.reduce(0) do |decimal, index|
      decimal += numeric_digits[index] * (base**(max_power - index))
    end
  end

  private

  def numeric_digits
    string_digits.chars.map(&method(:digit_to_decimal_int))
  end

  def digit_to_decimal_int(digit_string)
    digit_string.to_i
  end

  def valid?
    @base.size > 0 && valid_string?
  end

  def valid_string?
    !(@string_digits =~ /[^0-#{base - 1}]/)
  end

  def numeral_system_base
    10
  end
end

class Trinary < AnyBase
  private

  def numeral_system_base
    3
  end
end

class Octal < AnyBase
  private

  def numeral_system_base
    8
  end
end

class Hex < AnyBase
  HEX_LETTERS = {
    'a' => 10,
    'b' => 11,
    'c' => 12,
    'd' => 13,
    'e' => 14,
    'f' => 15
  }

  private

  def digit_to_decimal_int(digit)
    case digit
    when /[0-9]/
      digit.to_i
    else
      HEX_LETTERS[digit.downcase]
    end
  end

  def numeral_system_base
    16
  end

  def valid_string?
    !(@string_digits =~ /[^0-9abcdef]/i)
  end
end


if $PROGRAM_NAME == __FILE__
  p Octal.new('1').to_decimal
end