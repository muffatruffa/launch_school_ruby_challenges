class Triplet
  def initialize(first, second, addition)
    @first = first
    @second = second
    @addition = addition
  end

  def sum
    @first + @second + @addition
  end

  def product
    @first * @second * @addition
  end

  def pythagorean?
    ((@first * @first) + (@second * @second)) == (@addition * @addition)
  end

  def self.where(min_factor: 1, max_factor:, sum: nil)
    triplets = []
    addends_combinations_in(min_factor, max_factor) do |first, second|
      min_factor.upto(max_factor) do |allowed_factor|
        triplet_addends = [first, second, allowed_factor]
        triplet = Triplet.new(*triplet_addends)
        if triplet.pythagorean? && sum_constrain?(sum, triplet_addends)
          triplets << triplet
        end 
      end
    end
    triplets
  end

  def self.addends_combinations_in(min, max)
    first = min

    while first <= max
      second = first
      while second <=max
        if (first * first + second * second) <= max * max
          yield(first, second)
        end
        second += 1
      end
      first += 1
    end
  end

  def self.sum_constrain?(sum = nil, addends = nil)
    return true unless sum
    sum == addends.reduce(&:+)
  end
end

if $PROGRAM_NAME == __FILE__
  triplets = Triplet.where(sum: 180, max_factor: 100)
end