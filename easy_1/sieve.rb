class Sieve
  def initialize(limit)
    @limit = limit
  end

  def primes
    # last index in array is the limit
    all_in_range = Array.new(@limit+1, true)
    prime = 2
    while prime * prime <= @limit
      if all_in_range[prime]
        first_factor = prime
        while prime * first_factor <= @limit
          all_in_range[prime * first_factor] = false
          first_factor += 1
        end
      end
      prime += 1
    end

    (2..@limit).select {|cadidate_prime| all_in_range[cadidate_prime]}
  end

#   def primes
#     # last index in array is the limit
#     # all marked as prime at the beginning
#     all_in_range = Array.new(@limit+1, true)

#     (2...@limit).each do |index|
#       multiples = ((index * index)..@limit).step(index)
#       multiples.each { |index_multiple| all_in_range[index_multiple] = false }
#     end
#     all_in_range.each_index.select { |index| all_in_range[index] && index >= 2}
#   end
end

# class Sieve
#   def initialize(number)
#     @range = (2..number).to_a
#   end

#   def primes
#     @range.each_with_index do |num, i|
#       next unless num

#       j = i + num
#       while j < @range.size
#         @range[j] = nil
#         j += num
#       end
#     end

#     @range.select{ |num| num }
#   end
# end


if __FILE__ == $PROGRAM_NAME
  p Sieve.new(10).primes
end