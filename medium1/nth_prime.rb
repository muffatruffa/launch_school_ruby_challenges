# Posted solution
module EnumeratorPredicate
  def enum_select
    @enum_select ||= (from..Float::INFINITY).lazy.select { |n| predicate?(n) }
  end

  def nth(count)
    enum_select.take(count).force.last
  end

  def take_n(n)
    enum_select.take(n).to_a
  end
end

class Prime
  include EnumeratorPredicate

  def self.nth(prime_th)
    raise ArgumentError if prime_th.zero?
    new.nth(prime_th)
  end

  def from
    2
  end

  def predicate?(n)
    current = 2
    while current * current <= n
      return false if (n % current).zero?
      current += 1
    end
    true
  end
end



# class Prime
#   PRIMES = (2..Float::INFINITY).lazy.select { |n| Prime.prime?(n) }

#   def self.nth(prime_th)
#     raise ArgumentError if prime_th.zero?
#     PRIMES.take(prime_th).force.last
#   end

#   def self.prime?(n)
#     current = 2
#     while current * current <= n
#       return false if (n % current).zero?
#       current += 1
#     end
#     true
#   end
# end

# class Prime
#   def self.nth(prime_th)
#     raise ArgumentError if prime_th.zero?
#     current_prime = 2
#     prime_count = 1
#     until prime_count == prime_th
#       current_prime += 1
#       prime_count += 1 if prime?(current_prime)
#     end
#     current_prime
#   end

#   def self.prime?(n)
#     current = 2
#     while current * current <= n
#       return false if (n % current).zero?
#       current += 1
#     end
#     true
#   end
# end

# class Prime
#   def self.nth(prime_count)
#     raise ArgumentError if prime_count.zero?
#     @primes_sofar = [2]
#     current = 3
#     until @primes_sofar.size == prime_count
#       @primes_sofar << current if prime?(current)
#       current += 2
#     end
#     @primes_sofar.last
#   end


#   def self.prime?(n)
#     !@primes_sofar.any? do |smaller_than_n_prime|
#       return true if smaller_than_n_prime**2 > n
#      (n % smaller_than_n_prime).zero?
#    end
#   end
# end

if $PROGRAM_NAME == __FILE__

end