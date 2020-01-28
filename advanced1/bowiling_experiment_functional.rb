class NotPlayed; end

class Game
  def initialize
    @update_frames = update_frames
    @frames = []
  end

  def roll(knocked_pins)
    unless knocked_pins >= 0 && knocked_pins <= 10
      raise RuntimeError, 'Pins must have a value from 0 to 10'
    end

    if rolls_limit_over?
      raise RuntimeError, 'Should not be able to roll after game is over'
    end

    if knocked_pins == 10 or last_spare?
      @update_frames = @update_frames[knocked_pins][NotPlayed.new]
    else
      @update_frames = @update_frames[knocked_pins]
    end
   end

  def score
    if @frames.size < 10
      raise  RuntimeError, 'Score cannot be taken until the end of the game'
    end

    if fill_balls_coming?
      raise RuntimeError, 'Game is not yet over, cannot score!'
    end

    sum_knocked_pins + strike_spare_bonus
  end

  def last_spare?
    @frames.size == 10 &&
    @frames.last.inject(&:+) == 10 && @frames.last.size == 2
  end

  def last_strike?
    @frames.size == 10 &&
    @frames.last == [10]
  end

  def rolls_limit_over?
    return @frames.size == 11 if last_spare?
    return @frames.size == 12 if last_strike?

    @frames.size == 10
  end

  def fill_balls_coming?
    last_spare? && @frames.size < 11 ||
    last_strike? && @frames.size < 12
  end

  def sum_knocked_pins
    @frames.flatten.inject(&:+)
  end

  def strike_spare_bonus
    total = 0
    @frames.each_index do |index|
      total += frame_strike_bonus(@frames[index], index)
      total += frame_spare_bonus(@frames[index], index)
      break if index == 8
    end
    total
  end

  def frame_strike_bonus(frame, frame_index)
    return 0 unless frame == [10]
    sum_twice(@frames[frame_index + 1..frame_index + 2], 0)
  end

  def frame_spare_bonus(frame, frame_index)
    return 0 unless frame.inject(&:+) == 10 && frame.size > 1
    @frames[frame_index + 1].first
  end

  def sum_twice(ar, sum)
    rec_twice = ->(ar, sum, count) do
      if count == 2
        sum
      else
        if ar[0].empty?
          rec_twice.(ar[1..-1], sum, count)
        else
          rec_twice.(ar[1..-1].prepend(ar[0][1..-1]), sum + ar[0].first, count + 1)
        end
      end
    end

    return sum + ar.flatten.inject(&:+) if ar.flatten.size < 2

    rec_twice.(ar, sum, 0)
  end

  def update_frames
    insert_in_frames = ->(first_ball, second_ball) do
      if second_ball.kind_of?(NotPlayed)
        @frames << [first_ball]
      else
        if first_ball + second_ball > 10
          raise RuntimeError, 'Pin count exceeds pins on the lane'
        end

        @frames << [first_ball, second_ball]
      end
      insert_in_frames.curry
    end
    insert_in_frames.curry
  end
end

if $PROGRAM_NAME == __FILE__
  require 'pry'
  game = Game.new

  def roll_n_times(rolls, pins, game)
    rolls.times do
      Array(pins).each { |value| game.roll(value) }
    end
  end

    roll_n_times(12, 10, game)
    p game.update_frames.parameters

    # # game.roll(50)
    # binding.pry
     game.score # 17

  # p game.frames


end