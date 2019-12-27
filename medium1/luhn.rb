class Luhn
  def initialize(number_with_check_digit)
    @luhn_base = number_with_check_digit
  end

  def addends
    digits_addends = base_to_digits
    positions_to_double.each_with_object(digits_addends) do |positions, digits|
      digits[positions] = digit_to_luhn(digits[positions])
    end
  end

  def checksum
    addends.inject(&:+)
  end

  def valid?
    (checksum % 10).zero?
  end

  def self.create(number)
    (number * 10) + check_digit_for(number).first
  end


  def self.check_digit_for(number)
    (0..9).select do |candidate|
      plus_digit = (number * 10 ) + candidate
      new(plus_digit).valid?
    end
  end

  def digit_to_luhn(digit)
    case 2 * digit
    when (0..9) then 2 * digit
    else 2 * digit - 9
    end
  end

  def positions_to_double
    (-(base_to_digits.size - 2)..0).step(2).map(&:abs)
  end

  def base_to_digits
    @luhn_base.to_s.chars.map(&:to_i)
  end
end

if $PROGRAM_NAME == __FILE__
  l = Luhn.new(8_739_567)
  p l.addends
  p l.checksum
  p l = Luhn.check_digit_for(873_956)
end