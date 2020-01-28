module CompositionConverter
  TOTAL_CARDS = 5

  module_function
  def Composition(cards)
    case cards
    when straight_flush? then StraightFlush.new(cards)
    when ace_low_straight_flush? then StraightFlush.new(set_ace_rank_one(cards))
    when four_of_a_kind? then FourOfAKind.new(cards)
    when full_house? then FullHouse.new(cards)
    when flush? then Flush.new(cards)
    when straight? then Straight.new(cards)
    when ace_low_straight? then Straight.new(set_ace_rank_one(cards))
    when three_of_a_kind? then ThreeOfAKind.new(cards)
    when two_pair? then TwoPair.new(cards)
    when one_pair? then OnePair.new(cards)
    else
      HighCard.new(cards)
    end
  end

  def straight_flush?
    ->(cards) do
      flush?.(cards) && straight?.(cards)
    end
  end

  def ace_low_straight_flush?
    ->(cards) do
      flush?.(cards) && ace_low_straight?.(cards)
    end
  end

  def four_of_a_kind?
    ->(cards) do
      group_cards_by_rank(cards).values.map(&:size).include? 4
    end
  end

  def full_house?
    ->(cards) do
      three_of_a_kind?.(cards) && one_pair?.(cards)
    end
  end

  def flush?
    ->(cards) do
      all_same_suit?(cards)
    end
  end

  def straight?
    ->(cards) do
      sequential_ranks_count(cards) == TOTAL_CARDS
    end
  end
 
  def ace_low_straight?
    ->(cards) do
      sorted_ranks = cards.map(&:rank).sort
      
      (sequential_ranks_count(cards) == TOTAL_CARDS - 1) &&
      (sorted_ranks[0] == 2 && sorted_ranks[1] == 3 && sorted_ranks.last == 14)
    end
  end

  def three_of_a_kind?
    ->(cards) do
      group_cards_by_rank(cards).values.map(&:size).include? 3
    end
  end

  def two_pair?
    ->(cards) do
      group_cards_by_rank(cards).values.map(&:size).sort == [1,2,2]
    end
  end

  def one_pair?
    ->(cards) do
      group_cards_by_rank(cards).values.map(&:size).include? 2
    end
  end

  def all_same_suit?(cards)
    cards.all? { |card| cards[0].suit == card.suit}
  end

  def group_cards_by_rank(cards)
    cards.group_by(&:rank)
  end

  def sequential_ranks_count(cards)
    # count_sequentials of one element array is 1
    count_sequentials = ->(ranks, count) do
      if ranks.size == 1
        count
      else
        if ranks[0] + 1 == ranks[1]
          count_sequentials.(ranks[1..-1], count + 1)
        else
          count_sequentials.(ranks[1..-1], count)
        end
      end
    end
    return 0 if cards.empty?
    ranks = cards.map(&:rank).sort
    count_sequentials.(ranks, 1)
  end

  def set_ace_rank_one(cards)
    cards.each { |card| card.rank = 1 if card.rank == 14 }
  end
end