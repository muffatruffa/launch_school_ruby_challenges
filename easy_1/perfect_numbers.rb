class PerfectNumber
  def self.classify(number)
    raise RuntimeError if number < 0
    sum_of_factors = divisors_sum(number)
    if number == sum_of_factors
      'perfect'
    elsif number < sum_of_factors
      'abundant'
    else
      'deficient'
    end
  end

  def self.divisors_sum(number)
    sum = 1
    divisor = 2
    while divisor * divisor < number
      if number % divisor == 0
        sum += divisor
        sum += number / divisor unless divisor == number / divisor
      end
      divisor += 1
    end
    sum
  end
end

if $PROGRAM_NAME == __FILE__
  p PerfectNumber.divisors_sum(13)
  p PerfectNumber.divisors_sum(28)
  p PerfectNumber.divisors_sum(12)
end