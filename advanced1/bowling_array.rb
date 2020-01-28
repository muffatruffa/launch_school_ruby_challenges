class Game
  attr_reader :frames
  FRAMES_COUNT = 10

  def initialize
    @frames = Array.new(FRAMES_COUNT) { |position| Frame.new(position) }
    @knocked_pins = []
  end

  def roll(knocked_pins)
    if knocked_pins < 0
      raise RuntimeError, 'Pins must have a value from 0 to 10'
    end

    if knocked_pins > 10
      raise RuntimeError, 'Pins must have a value from 0 to 10'
    end

    if @frames.last.closed?
      raise RuntimeError, 'Should not be able to roll after game is over'
    end


    current_frame.add_roll(knocked_pins)
  end

  def score
    unless @frames.last.closed?
      raise RuntimeError, 'Score cannot be taken until the end of the game'
    end
    total = 0
    0.upto(@frames.size - 1) do |frame_index|
      total += @frames[frame_index].score(@frames[frame_index + 1..-1])
    end
    total
  end

  def current_frame
    @frames.drop_while { |frame| frame.closed? }.first
  end
end

class Frame
  attr_reader :first, :last, :position, :first_fill_ball, :second_fill_ball
  def initialize(position)
    @closed = false
    @position = position
  end

  def add_roll(knocked_pins)
    return play_first(knocked_pins) if first_roll?

    return play_fill_ball(knocked_pins) if fill_ball?

    play_last(knocked_pins)
  end

  def score(following_frames)
    first.score(following_frames) + last.score(following_frames) + fill_ball_score
  end

  def fill_ball_score
    score = 0
    score += first_fill_ball.knocked unless first_fill_ball.nil?
    score += second_fill_ball.knocked unless second_fill_ball.nil?
    score
  end

  def knocked_pins
    first.knocked + last.knocked
  end

  def play_first(knocked)
    if knocked == 10
      @first = Strike.new(knocked)
      @last = NotPlayed.new
      @closed = true unless position == 9 
    else
      @first = Open.new(knocked)
    end
  end

  def play_fill_ball(knocked_pins)
    if @first_fill_ball.nil?
      @closed = true if last.kind_of? Spare
      return @first_fill_ball = Open.new(knocked_pins)
    end

    if @first_fill_ball.knocked < 10 && @first_fill_ball.knocked + knocked_pins > 10
      raise RuntimeError, 'Pin count exceeds pins on the lane'
    end
    @second_fill_ball = Open.new(knocked_pins)
    @closed = true
  end


  def play_last(knocked)
    if knocked + first.knocked > 10
      raise RuntimeError, 'Pin count exceeds pins on the lane'
    end
    if (knocked + first.knocked) == 10
      @last = Spare.new(knocked)
      @closed = true unless position == 9
    else
      @last = Open.new(knocked) 
      @closed = true
    end
  end

  def first_roll?
    @first.nil?
  end

  def fill_ball?
    return true if (!last.nil? && strike_or_spare?)
    false 
  end

  def strike_or_spare?
    first.kind_of?(Strike) || last.kind_of?(Spare)
  end

  def closed?
    @closed
  end
end

class Roll
  attr_reader :knocked

  def initialize(knocked)
    @knocked = knocked
  end

  def score(following_frames = [])
    knocked + add_bonus(following_frames)
  end
end

class Strike < Roll
  def add_bonus(following_frames)
    return 0 if following_frames.empty?

    total = 0
    total += following_frames[0].knocked_pins

    if following_frames.size == 1
      if following_frames[0].first.kind_of? Strike
        total += following_frames[0].first_fill_ball.knocked
      end
    else
      if following_frames[0].first.kind_of? Strike
        total += following_frames[1].first.knocked
      end
    end
    
    total
  end

end

class Spare < Roll
  def add_bonus(following_frames)
    return 0 if following_frames.empty?
    following_frames[0].first.knocked
  end
end

class Open < Roll
  def add_bonus(_following_frames)
    0
  end
end

class NotPlayed < Roll
  def initialize
    @knocked = 0
  end

  def add_bonus(_following_frames)
    0
  end
end