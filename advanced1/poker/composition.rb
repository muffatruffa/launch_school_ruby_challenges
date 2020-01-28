require_relative 'composition_converter'

class Composition
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def <=>(other)
    return nil unless other.instance_of? self.class
    if rank_first_by.<=>(other.rank_first_by) == 0
      then_by.<=>(other.then_by)
    else
      rank_first_by.<=>(other.rank_first_by)
    end
  end

  private

  def n_kind_rank(n)
    cards.group_by(&:rank).values.find { |cards| cards.size == n }.map(&:rank)
  end

  def n_kind_rank_reject(n)
    card = cards.group_by(&:rank).reject { |rank, cards| cards.size == n }.values
    card_rank = card.map { |card| card.map(&:rank) }
  end

  def reverse_sorted_cards_ranks
    @cards.map(&:rank).sort { |a, b| b <=> a }
  end

  def not_three_kind_reverse_sorted
    not_three_cards = cards.group_by(&:rank).values.reject { |cards| cards.size == 3 }
    cards_rank = not_three_cards.flatten.map(&:rank).sort { |a,b| b <=> a }
  end

  def sorted_double_pair_ranks
    pairs_cards =cards.group_by(&:rank).select { |rank, cards| cards.size == 2 }.values
    pairs_ranks = pairs_cards.map { |pair| pair.map(&:rank) }.sort { |a, b| b <=> a }
  end

  def not_double_pair_rank
    n_kind_rank_reject(2)
  end

  def reverse_order_not_pair
    remaining = @cards.group_by(&:rank).reject { |rank, cards| cards.size == 2 }
    remaining.values.flatten.map(&:rank).sort { |rank_a, rank_b| rank_b <=> rank_a }
  end

end

class StraightFlush < Composition
  def rank
    10
  end

  def rank_first_by
    reverse_sorted_cards_ranks
  end

  def then_by
    reverse_sorted_cards_ranks
  end
end

class FourOfAKind < Composition
  def rank
    9
  end

  def rank_first_by
    n_kind_rank(4)
  end

  def then_by
    n_kind_rank(1)
  end
end

class FullHouse < Composition
  def rank
    8
  end

  def rank_first_by
    n_kind_rank(3)
  end

  def then_by
    n_kind_rank(2)
  end
end

class Flush < Composition
  def rank
    7
  end

  def rank_first_by
    reverse_sorted_cards_ranks
  end

  def then_by
    reverse_sorted_cards_ranks
  end
end

class Straight < Composition
  def rank
    6
  end

  def rank_first_by
    reverse_sorted_cards_ranks
  end

  def then_by
    reverse_sorted_cards_ranks
  end
end

class ThreeOfAKind < Composition
  def rank
    5
  end

  def rank_first_by
    n_kind_rank(3)
  end

  def then_by
    not_three_kind_reverse_sorted
  end
end

class TwoPair < Composition
  def rank
    4
  end

  def rank_first_by
    sorted_double_pair_ranks
  end

  def then_by
    not_double_pair_rank
  end
end

class OnePair < Composition
  def rank
    3
  end

  def rank_first_by
    n_kind_rank(2)
  end

  def then_by
    reverse_order_not_pair
  end
end

class HighCard < Composition
  def rank
    2
  end

  def rank_first_by
    reverse_sorted_cards_ranks
  end

  def then_by
    reverse_sorted_cards_ranks
  end
end








# require_relative 'composition_converter'

# class Composition
#   attr_reader :cards

#   def initialize(cards)
#     @cards = cards
#   end

#   def reverse_sorted_cards_ranks
#     @cards.map(&:rank).sort { |a, b| b <=> a }
#   end

#   def <=>(other)
#     return nil unless other.instance_of? self.class
#     if rank_first_by.<=>(other.rank_first_by) == 0
#       then_by.<=>(other.then_by)
#     else
#       rank_first_by.<=>(other.rank_first_by)
#     end
#   end
# end

# class StraightFlush < Composition
#   def rank
#     10
#   end

#   def <=>(other)
#     super(other)
#     reverse_sorted_cards_ranks.<=>(other.reverse_sorted_cards_ranks)
#   end

#   def rank_first_by
#   end

#   def then_by
#   end
# end

# class FourOfAKind < Composition
#   def rank
#     9
#   end

#   def <=>(other)
#     super(other)
#     if four_kind_rank.<=>(other.four_kind_rank) == 0
#       one_rank.<=>(other.one_rank)
#     else
#       four_kind_rank.<=>(other.four_kind_rank)
#     end
#   end

#   def four_kind_rank
#     cards.group_by(&:rank).values.find { |cards| cards.size == 4 }.map(&:rank)
#   end

#   def one_rank
#     cards.group_by(&:rank).values.find { |cards| cards.size == 1 }.map(&:rank)
#   end
# end

# class FullHouse < Composition
#   def rank
#     8
#   end

#   def <=>(other)
#     super(other)
#     if three_kind_rank.<=>(other.three_kind_rank) == 0
#       pair_rank.<=>(other.pair_rank)
#     else
#       three_kind_rank.<=>(other.three_kind_rank)
#     end
#   end

#   def three_kind_rank
#     cards.group_by(&:rank).values.find { |cards| cards.size == 3 }.map(&:rank)
#   end

#   def pair_rank
#     cards.group_by(&:rank).values.find { |cards| cards.size == 2 }.map(&:rank)
#   end
# end

# class Flush < Composition
#   def rank
#     7
#   end

#   def <=>(other)
#     super(other)
#     reverse_sorted_cards_ranks.<=>(other.reverse_sorted_cards_ranks)
#   end
# end

# class Straight < Composition
#   def rank
#     6
#   end

#   def <=>(other)
#     super(other)
#     reverse_sorted_cards_ranks.<=>(other.reverse_sorted_cards_ranks)
#   end
# end

# class ThreeOfAKind < Composition
#   def rank
#     5
#   end

#   def <=>(other)
#     super(other)
#     if three_kind_rank.<=>(other.three_kind_rank) == 0
#       not_three_kind_reverse_sorted.<=>(other.not_three_kind_reverse_sorted)
#     else
#       three_kind_rank.<=>(other.three_kind_rank)
#     end
#   end

#   def three_kind_rank
#     cards.group_by(&:rank).values.find { |cards| cards.size == 3 }.map(&:rank)
#   end

#   def not_three_kind_reverse_sorted
#     not_three_cards = cards.group_by(&:rank).values.reject { |cards| cards.size == 3 }
#     cards_rank = not_three_cards.flatten.map(&:rank).sort { |a,b| b <=> a }
#   end
# end

# class TwoPair < Composition
#   def rank
#     4
#   end

#   def <=>(other)
#     super(other)
#     if sorted_double_pair_ranks.<=>(other.sorted_double_pair_ranks) == 0
#       not_double_pair_rank.<=>(other.not_double_pair_rank)
#     else
#       sorted_double_pair_ranks.<=>(other.sorted_double_pair_ranks)
#     end
#   end

#   def sorted_double_pair_ranks
#     pairs_cards =cards.group_by(&:rank).select { |rank, cards| cards.size == 2 }.values
#     pairs_ranks = pairs_cards.map { |pair| pair.map(&:rank) }.sort { |a, b| b <=> a }
#   end

#   def not_double_pair_rank
#     card = cards.group_by(&:rank).reject { |rank, cards| cards.size == 2 }.values
#     card_rank = card.map { |card| card.map(&:rank) }
#   end
# end

# class OnePair < Composition
#   def rank
#     3
#   end

#   def <=>(other)
#     super(other)
#     return nil unless other.instance_of? OnePair
#     # pair <=> other.pair
#     if pair.<=>(other.pair) == 0
#       reverse_order_not_pair.<=>(other.reverse_order_not_pair)
#     else
#       pair.<=>(other.pair)
#     end
#   end

#   def pair
#     pair_hash = @cards.group_by(&:rank).select { |rank, cards| cards.size == 2 }
#     pair_hash.values.flatten.map(&:rank)
#   end

#   def reverse_order_not_pair
#     remaining = @cards.group_by(&:rank).reject { |rank, cards| cards.size == 2 }
#     remaining.values.flatten.map(&:rank).sort { |rank_a, rank_b| rank_b <=> rank_a }
#   end
# end

# class HighCard < Composition
#   def rank
#     2
#   end

#   def <=>(other)
#     super(other)
#     reverse_sorted_cards_ranks.<=>(other.reverse_sorted_cards_ranks)
#   end
# end
