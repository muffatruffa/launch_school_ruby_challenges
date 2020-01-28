class Card
  attr_reader :suit
  attr_accessor :rank

  def initialize(rank, suit, rank_suit)
    @rank = rank
    @suit = suit
    @rank_suit = rank_suit
  end

  def self.for(rank_suit)
    case rank_suit
    when String
      raise ArgumentError, "#{suit_s} is not a valid suit" if rank_suit.size < 2

      new(rank(rank_suit[0]), suit(rank_suit[1]), rank_suit)
    else
      raise ArgumentError, "#{rank_suit} has to be a two charater String"
    end
  end

  def self.suit(suit_s)
    case suit_s
    when /s/i then :spades
    when /h/i then :hearts
    when /c/i then :clubs
    when /d/i then :diamonds
    else
      raise ArgumentError, "#{suit_s} is not a valid suit"
    end
  end

  def self.rank(rank_s)
    case rank_s
    when /\d/ then rank_s.to_i
    when /T/ then 10
    when /J/ then 11
    when /Q/ then 12
    when /K/ then 13
    when /A/ then 14
    else
      raise ArgumentError, "#{rank_s} is not valid."
    end
  end

  def to_s
    @rank_suit
  end
end
