class SumOfMultiples
  attr_reader :multiples_of

  def initialize(*multiples_of)
    @multiples_of = multiples_of_or_default(multiples_of)
  end

  def to(limit)
    multiples_of.each_with_object([0]) do |n, multiples|
      multiples.concat(multiples_of_n(n, limit)).uniq!
    end.reduce(&:+)
  end

  def self.to(limit)
    new.to(limit)
  end

  private

  def multiples_of_or_default(multiples_of)
    return [3, 5] if multiples_of.empty?
    multiples_of
  end

  def multiples_of_n(n, limit)
    return [0] if n >= limit

    (n...limit).step(n).to_a
  end
end
