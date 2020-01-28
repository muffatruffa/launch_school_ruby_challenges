class Game
  attr_reader :frames

  def initialize
    @closed = false
    start_frames
  end

  def roll(knocked_pins)
    if knocked_pins < 0 || knocked_pins > 10
      raise RuntimeError, 'Pins must have a value from 0 to 10'
    end
    
    if closed?
      raise RuntimeError, 'Should not be able to roll after game is over'
    end

    current_frame.play(knocked_pins)
  end

  def score
    unless closed?
      raise RuntimeError, 'Score cannot be taken until the end of the game'
    end

    total = 0
    each do |frame|
      total += frame.score
    end
    total
  end

  def current_frame
    each do |frame|
      break frame unless frame.played?
    end
  end

  def start_frames
    @frames = TenFrame.new
    9.times do |_|
      @frames = Frame.new(@frames)
    end
  end

  def closed?
    last_frame.played?
  end

  def last_frame
    each do |frame|
      break frame if frame.last?
    end
  end

  def each
    current = frames
    until current.kind_of? Empty
      yield current
      current = current.next
    end
    frames
  end
end

class Frame
  attr_reader :next, :first_throw, :second_throw

  def initialize(frame)
    @played = false
    @next = frame
  end

  def score
    @first_throw.score(self) + @second_throw.score(self)
  end

  def played?
    @played
  end

  def play(knocked_pins)
    if first_throw?
      play_first(knocked_pins)
      @played = true if first_throw.strike?
    else
      play_second(knocked_pins)
      @played = true
    end
  end

  def play_first(knocked_pins)
    if knocked_pins == 10
      @first_throw = Strike.new(knocked_pins)
      @second_throw = NotPlayed.new
    else
      @first_throw = Open.new(knocked_pins)
    end
  end

  def play_second(knocked_pins)
    if @first_throw.knocked + knocked_pins > 10
      raise RuntimeError, 'Pin count exceeds pins on the lane'
    end

    if @first_throw.knocked + knocked_pins == 10
      @second_throw = Spare.new(knocked_pins)
    else
      @second_throw = Open.new(knocked_pins)
    end
  end

  def first_throw?
    @first_throw.nil?
  end

  def second_throw?
    !first_throw? && @second_throw.nil?
  end

  def last?
    kind_of? TenFrame
  end

  def strike_bonus
    total = first_throw.knocked + second_throw.knocked
    if first_throw.strike?
      total += self.next.first_throw.knocked
    end
    total
  end

  def spare_bonus
    first_throw.knocked
  end
end

class TenFrame < Frame
  attr_reader :first_fill_ball, :second_fill_ball

  def initialize
    @played = false
    @next = Empty.new
    @first_fill_ball = NotPlayed.new
    @second_fill_ball = NotPlayed.new
  end

  def score
    @first_throw.knocked + @second_throw.knocked +
    @first_fill_ball.knocked + @second_fill_ball.knocked
  end

  def play(knocked_pins)
    if first_throw?
      play_first(knocked_pins)
    elsif second_throw?
      play_second(knocked_pins)
      @played = true unless second_throw.spare?
    else
      play_fill_balls(knocked_pins)
    end
  end

  def play_fill_balls(knocked_pins)
    if @first_fill_ball.not_played?
      @first_fill_ball = Open.new(knocked_pins)
      @played = true unless @first_throw.strike?
    else

      if not_allowed_knocked_pins?(knocked_pins)
        raise RuntimeError, 'Pin count exceeds pins on the lane'
      end

      @second_fill_ball = Open.new(knocked_pins)
      @played = true
    end
  end

  def not_allowed_knocked_pins?(knocked_pins)
    @first_fill_ball.knocked < 10 &&
    (@first_fill_ball.knocked + knocked_pins) > 10
  end

  def strike_bonus
    first_throw.knocked + second_throw.knocked + first_fill_ball.knocked
  end
end

class Empty < Frame
  def initialize
    @played = true
    @first_throw = NotPlayed.new
    @second_throw = NotPlayed.new
  end
end

class Roll
  attr_reader :knocked

  def initialize(knocked)
    @knocked = knocked
  end

  def score(frame)
    knocked + add_bonus(frame)
  end

  def strike?
    kind_of? Strike
  end

  def spare?
    kind_of? Spare
  end

  def not_played?
    kind_of? NotPlayed
  end
end

class Strike < Roll
  def add_bonus(frame)
    frame.next.strike_bonus
  end

end

class Spare < Roll
  def add_bonus(frame)
    frame.next.spare_bonus
  end
end

class Open < Roll
  def add_bonus(_frame)
    0
  end
end

class NotPlayed < Roll
  def initialize
    @knocked = 0
  end

  def add_bonus(_frame)
    0
  end
end

if $PROGRAM_NAME == __FILE__
  require 'pry'
  def roll_n_times(rolls, pins, game)
    rolls.times do
      Array(pins).each { |value| game.roll(value) }
    end
  end
  
  game = Game.new
  roll_n_times(18, 0, game)
  game.roll(9)
  game.roll(1)
  
  game.roll(7)

  game.score


  # game = Game.new
  # def roll_n_times(rolls, pins, game)
  #   rolls.times do
  #     Array(pins).each { |value| game.roll(value) }
  #   end
  # end
  # roll_n_times(18, 0, game)
  # game.roll(9)
  # game.roll(1)
  # binding.pry
  # game.roll(7)
  # game.score
end