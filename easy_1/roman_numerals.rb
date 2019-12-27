# module RomanNumerals
#   def self.position_0(digit)
#     case digit
#     when 4 then 'IV'
#     when 5 then 'V'
#     when 9 then 'IX'
#     when (6..8) then "V#{'I' * (digit - 5)}"
#     when (1..3) then "I" * digit
#     else ''
#     end
#   end

#   def self.position_1(digit)
#     case digit
#     when 4 then 'XL'
#     when 5 then 'L'
#     when 9 then 'XC'
#     when (6..8) then "L#{'X' * (digit - 5)}"
#     when (1..3) then "X" * digit
#     else ''
#     end
#   end

#   def self.position_2(digit)
#     case digit
#     when 4 then 'CD'
#     when 5 then 'D'
#     when 9 then 'CM'
#     when (6..8) then "D#{'C' * (digit - 5)}"
#     when (1..3) then "C" * digit
#     else ''
#     end
#   end

#   def self.position_3(digit)
#     case digit
#     when (1..9) then "M" * digit
#     else ''
#     end
#   end

#   def self.digits_to_romans(number)
#     digits = number.to_s.chars
#     digits.map.with_index do |digit, index|
#       position = (digits.size - 1) - index
#       send("position_#{position}".to_sym, digit.to_i)
#     end
#   end
# end

# class Fixnum
#   def to_roman
#     RomanNumerals::digits_to_romans(self).join('')
#   end
# end

module RomanNumerals
    TEN_POWERS = ['I', 'X', 'C','M']
    FIVE_TEN_PRODUCT = ['V', 'L', 'D']

  def self.digit_to_roman(digit, position)
    case digit
    when 4
      digit_to_roman(1, position) +  digit_to_roman(5, position)
    when 5
      FIVE_TEN_PRODUCT.at(position)
    when 9
      digit_to_roman(1, position) + digit_to_roman(1, position + 1)
    when (6..8)
      digit_to_roman(5, position) + digit_to_roman(digit - 5, position)
    when (1..3)
      TEN_POWERS.at(position) * digit
    else ''
    end
  end

  def self.digits_to_romans(number)
    digits = number.to_s.chars.map(&:to_i)
    digits.map.with_index do |digit, index|
      position = (digits.size - 1) - index
      digit_to_roman(digit, position)
    end
  end
end

class Fixnum
  def to_roman
    RomanNumerals::digits_to_romans(self).join('')
  end
end

if $PROGRAM_NAME == __FILE__
p  15.to_roman
p  2.to_roman
p  3.to_roman
p  4.to_roman
p  5.to_roman
p  6.to_roman
p  7.to_roman
p  8.to_roman
p  9.to_roman
p  0.to_roman
end