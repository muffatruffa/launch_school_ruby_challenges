module FactorsInRangePalindrome
  Palindrome = Struct.new(:value, :factors)
  def set_range(min, max)
    @min = min
    @max = max
  end

  def factors(n)
    return [] if n < @min
    result = []
    current = @min
    while current * current <= n
      if n/current <= @max
        result << [current, n/current] if (n % current).zero?
      end
      current +=1
    end
    result
  end

  def select_valid_smallest_largest
    palindrome_hash = build_palindromes(@min, @max).map do |plainidrome|
      [plainidrome, factors(plainidrome)]
    end.to_h.reject { |_, f| f.empty?}
    
    palindromes = palindrome_hash.keys.sort
    
    [
      Palindrome.new(palindromes.first, palindrome_hash[palindromes.first]),
      Palindrome.new(palindromes.last, palindrome_hash[palindromes.last])
    ]
  end
end

module PalindromesLoopSelector
  Plaindrome = Struct.new(:value, :factors) do
    def update(new_value, factor_pair)
      if new_value == value
        factors << factor_pair if new_pair?(factor_pair)
      else
        self.value = new_value
        self.factors = [factor_pair]
      end
    end

    def new_pair?(pair)
      !factors.include?(pair) &&
      !factors.include?(pair.reverse)
    end
  end

  def smallest_largest
    sm = Plaindrome.new(@max * @max, [])
    lg = Plaindrome.new(@min * @min, [])

    first_factor = @min
    
    while first_factor <= @max
      second_factor = first_factor
      first_factor.upto(@max) do |first|
        while second_factor <= @max
          current = first * second_factor
          if palindrome?(current)
            if current <= sm.value
              sm.update(current, [first, second_factor])
            end
            if current >= lg.value
              lg.update(current, [first, second_factor])
            end
          end
          second_factor += 1
        end
      end
      first_factor += 1
    end
    [
      sm,
      lg
    ]
  end

  module_function

  def palindrome?(n)
    n.to_s == n.to_s.reverse
  end
end

module PalindromesMapSelector
  def self.included klass
    klass.class_eval do
      include FactorsInRangePalindrome
    end
  end

  def smallest_largest
    select_valid_smallest_largest
  end

  module_function

  def build_palindromes(min, max)
    (min * min..max * max).to_a.select { |n|  n.to_s == n.to_s.reverse}
  end
end

module PalindromesBuilder
  def self.included klass
    klass.class_eval do
      include FactorsInRangePalindrome
    end
  end

  def smallest_largest
    select_valid_smallest_largest
  end

  module_function

  def build_palindromes(min, max)
    palindromes = []
    from = (min * min).to_s.size
    to = (max * max).to_s.size

    (from..to).each do |size|
      palindromes.concat build_n_digits_strings(size)
    end

    palindromes.reject do |palindorme|
      /\A0.*/ =~ palindorme || palindorme.to_i > max * max
    end.map(&:to_i)
  end

  def build_n_digits_strings(size)
    return ('0'..'9').to_a if size == 1

    if size.even?
      build_even(size)
    else
      build_odd(size)
    end
  end

  def build_even(size)
    palindromes = []
    ('0'..'9').to_a.repeated_permutation(size / 2).each do |digit_combination|
      str_combination = digit_combination.join('')
      palindromes << str_combination + str_combination.reverse
    end
    palindromes
  end

  def build_odd(size)
    palindromes = []
    ('0'..'9').to_a.repeated_permutation(size / 2).each do |digit_combination|
      str_combination = digit_combination.join('')
      ('0'..'9').to_a.each do |digit|
        palindromes << str_combination + digit + str_combination.reverse
      end
    end
    palindromes
  end
end

class PalindromeGenerator
  attr_reader :max, :min

  def self.get(max, min, palindromes_engineer = 'PalindromesBuilder')
    new(max, min, palindromes_engineer)
  end

  def initialize(max, min, palindromes_engineer = 'PalindromesBuilder')
    @max = max
    @min = min
    include_engineer_module(palindromes_engineer)
  end

  private

  def include_engineer_module(module_name)
    if Module.const_defined?(module_name)
      self.singleton_class.send(:include, Module.const_get(module_name))
    end
  end
end

class Palindromes
  attr_reader :largest, :smallest

  def initialize(max_factor:nil, min_factor:nil)
    @max = max_factor
    @min = min_factor || 1
    @palindromes_generator = if block_given?
      yield(@max, @min)
    else
      PalindromeGenerator.new(@max, @min)
    end
  end

  def generate
    @smallest, @largest = @palindromes_generator.smallest_largest
  end
end

if $PROGRAM_NAME == __FILE__
  require 'benchmark'
  palindromes = Palindromes.new(max_factor: 999, min_factor: 100) do |max, min|
    PalindromeGenerator.get(max, min, 'PalindromesLoopSelector')
  end
  p (Benchmark.realtime do # 0.164155626000138
    palindromes.generate
  end)

  palindromes = Palindromes.new(max_factor: 9999, min_factor: 1000) do |max, min|
    PalindromeGenerator.get(max, min, 'PalindromesLoopSelector')
  end
  p (Benchmark.realtime do # 16.31405066300067
    palindromes.generate
  end)

  palindromes = Palindromes.new(max_factor: 999, min_factor: 100) do |max, min|
    PalindromeGenerator.get(max, min, 'PalindromesMapSelector')
  end
  p (Benchmark.realtime do # 0.3845328660099767
    palindromes.generate
  end)

  palindromes = Palindromes.new(max_factor: 9999, min_factor: 1000) do |max, min|
    PalindromeGenerator.get(max, min, 'PalindromesMapSelector')
  end
  p (Benchmark.realtime do # 42.2232261300087
    palindromes.generate
  end)

  palindromes = Palindromes.new(max_factor: 999, min_factor: 100) do |max, min|
    PalindromeGenerator.get(max, min, 'PalindromesBuilder')
  end
  p (Benchmark.realtime do # 0.05663906500558369
    palindromes.generate
  end)

  palindromes = Palindromes.new(max_factor: 9999, min_factor: 1000) do |max, min|
    PalindromeGenerator.get(max, min, 'PalindromesBuilder')
  end
  p (Benchmark.realtime do # 3.7876757479971275
    palindromes.generate
  end)
end