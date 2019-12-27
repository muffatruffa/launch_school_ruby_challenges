module TimeConverter
  module_function

  MINUTES_IN_HOUR = 60
  HOUR_IN_DAY = 24
  MINUTES_IN_DAY = HOUR_IN_DAY * MINUTES_IN_HOUR

  Minutes = Struct.new(:minutes)


  # Similar to Array() return a new object of Clock
  # Taken from https://www.confidentruby.com/
  def Clock(*args)
    case args[0]
    when Minutes 
      hours, minutes = args[0].minutes.divmod(MINUTES_IN_HOUR)
      Clock.new(hours, minutes)
    when Array
      Clock.new(*args[0])
    when String
      Clock.new(*args[0].split(/[:\-\.]/).map(&:to_i))
    when Integer
      Clock.new(*args)
    else
      raise TypeError, "Cannot convert #{args.inspect} to Clock"
    end
  end

  def from_midnigth
    (hours * MINUTES_IN_HOUR) + minutes
  end

  def sum_from_midnigth(numeric)
    (from_midnigth + numeric) % MINUTES_IN_DAY
  end
end

class Clock
  include TimeConverter

  attr_reader :hours, :minutes

  def initialize(hours, minutes)
    @hours = hours
    @minutes = minutes
  end

  def to_s
    format('%02d:%02d', hours, minutes)
  end

  def +(numeric)
    new_minutes = Minutes.new(sum_from_midnigth(numeric))

    Clock(new_minutes)
  end

  def -(numeric)
    self.+(-numeric)
  end

  def ==(other)
    hours == other.hours && minutes == other.minutes
  end

  def self.at(hours, minutes = 0)
    Clock.new(hours, minutes)
  end
end

if $PROGRAM_NAME == __FILE__
  p TimeConverter.Clock([8,30])
  p TimeConverter.Clock('15.30')
  p TimeConverter.Clock(16,20)
end