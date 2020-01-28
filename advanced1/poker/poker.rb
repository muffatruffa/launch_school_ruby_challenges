require_relative 'card'
require_relative 'composition'
require_relative 'hand'

class Poker
  attr_reader :hands, :string_hands

  def initialize(hands)
    @string_hands = hands
    @hands = cards_hands
  end

  def best_hand
    first_best_hand = hands.sort { |hand_a, hand_b| hand_b <=> hand_a }.first
    # Hand #== is implemented by Comparable according to #<=>
    all = hands.select { |hand| hand == first_best_hand }
    all.map(&:to_s)
  end

  def cards_hands
    @string_hands.map do |cards|
      Hand.for(cards)
    end
  end
end

if $PROGRAM_NAME == __FILE__
three_of_4 = %w(4S 5H 4S 8D 4H)
straight_to_5 = %w(4S AH 3S 2D 5H)
    # game = Poker.new([three_of_4, straight_to_5])

    # p game.hands[1].composition
    cards = three_of_4.map { |card| Card.for(card) }
    c = CompositionConverter.Composition(cards)
    p c
end