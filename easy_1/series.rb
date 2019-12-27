# Write a program that will take a string of digits and give you
# all the possible consecutive number series of length n in that string.

# For example, the string "01234" has the following 3-digit series:
# - 012
# - 123
# - 234
# And the following 4-digit series:
# - 0123
# - 1234

class Series
  def initialize(digits)
    @digits = digits
    @numbers = @digits.chars.map(&:to_i)
  end

  # def slices(slice_length)
  #   raise ArgumentError if @digits.size < slice_length
    
  #   chars_to_i = ->(characters) { characters.map(&:to_i)}
  #   @digits.chars.each_cons(slice_length).map(&chars_to_i)
  # end

  # def slices(slice_length)
  #   raise ArgumentError if @digits.size < slice_length

  #   last_digit_index = @digits.size - slice_length

  #   (0..last_digit_index).map do |index|
  #     @numbers[index, slice_length]
  #   end
  # end

  def slices(slice_length)
    raise ArgumentError if @digits.size < slice_length

    digit_slices = ->(digits, slices) do
      if digits.size == slice_length
        return slices << digits
      else
        digit_slices.(digits[1..-1], slices << digits[0, slice_length])
      end
    end

    digit_slices.(@numbers, [])
  end
end