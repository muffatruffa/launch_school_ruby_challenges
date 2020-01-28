class Hand
  include CompositionConverter
  include Comparable

  attr_reader :composition, :cards

  def initialize(cards)
    @cards = cards
    @composition = Composition(cards)
  end

  def self.for(cards)
    new(cards.map { |card| Card.for(card) })
  end

  def each(&block)
    @cards.each(&block)
  end

  def rank
    composition.rank
  end

  def <=>(other)
    return nil unless other.instance_of? Hand
    if rank == other.rank
      composition.<=>(other.composition)
    else
      rank.<=>(other.rank)
    end
  end

  def to_s
    cards.map(&:to_s)
  end
end