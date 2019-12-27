require 'date'

class Meetup
  attr_reader :weekday, :schedule
  TEENTH = (13..19).to_a.freeze

  def initialize(month, year)
    @month = month
    @year = year 
  end

  def day(weekday, schedule)
    @weekday = weekday
    @schedule = schedule
    Date.new(@year, @month, calendar_day)
  end

  private

  def calendar_day
    send(schedule).day
  end

  def first
    date = Date.new(@year, @month, 1)
    until date.send("#{weekday}?".to_sym)
      date += 1
    end
    date
  end

  def second
    first + 7
  end

  def third
    first + 14
  end

  def fourth
    first + 21
  end

  def last
    date = first
    while date.month == @month
      date += 7
    end
    date - 7
  end

  def teenth
    date = first
    until TEENTH.include? date.day
      date += 7
    end
    date
  end
end

if $PROGRAM_NAME == __FILE__
  m = Meetup.new(12, 2019)
  p m.first_date(:wednesday)
end