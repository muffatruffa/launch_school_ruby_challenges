# class Octal
#   def initialize(octal_string)
#     @octal = octal_string
#     @base = 8
#   end

#   # def to_decimal
#   #   return 0 unless valid?

#   #   octal_digits = @octal.chars.map(&:to_i)
#   #   max_power = octal_digits.size - 1

#   #   octal_digits.each_index.reduce(0) do |decimal, index|
#   #     decimal += octal_digits[index] * (@base**(max_power - index))
#   #   end
#   # end

#   # def to_decimal
#   #   return 0 unless valid?

#   #   sum_powers_of_base = ->(digits, power, sum) do
#   #     return sum if power.zero?
#   #     current_decimal = digits[0] * (@base**power)
#   #     sum_powers_of_base.(digits[1..-1], power - 1, sum + current_decimal)
#   #   end
#   #   octal_digits = @octal.chars.map(&:to_i)
#   #   sum_powers_of_base.(octal_digits, octal_digits.size - 1, octal_digits.last)
#   # end

#   def to_decimal
#     return 0 unless valid?
#     numeric_digits = @octal.to_i

#     return numeric_digits if (numeric_digits / 10).zero?

#     sum_powers_of_base = ->(digits, power, sum) do
#       all_but_last, last_digit = digits.divmod(10)
#       current_decimal = last_digit * (@base**power)
      
#       return sum + current_decimal if all_but_last.zero?

#       sum_powers_of_base.(all_but_last, power + 1, sum + current_decimal)
#     end
    
#     sum_powers_of_base.(numeric_digits, 0, 0)
#   end


#   def valid?
#     @base.size > 0 && !(@octal =~ /[^0-7]/)
#   end
# end

class AnyBase
  attr_reader :base, :string_digits

  def initialize(string_digits)
    @string_digits = string_digits
    @base = numeral_system_base
  end

  def to_decimal
    return 0 unless valid?
    numeric_digits = @string_digits.to_i

    return numeric_digits if (numeric_digits / 10).zero?

    sum_powers_of_base = ->(digits, power, sum) do
      all_but_last, last_digit = digits.divmod(10)
      current_decimal = last_digit * (@base**power)
      
      return sum + current_decimal if all_but_last.zero?

      sum_powers_of_base.(all_but_last, power + 1, sum + current_decimal)
    end
    
    sum_powers_of_base.(numeric_digits, 0, 0)
  end


  def valid?
    @base.size > 0 && !(@string_digits =~ /[^0-#{base - 1}]/)
  end  
end

class Octal < AnyBase
  def numeral_system_base
    8
  end
end

if $PROGRAM_NAME == __FILE__
  p Octal.new('1').to_decimal
end