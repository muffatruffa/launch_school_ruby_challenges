class Robot
  @used_names = []

  NAME_ALPHA_NUMBER = 2
  NAME_DIGIT_NUMBER = 3
  ALLOWED_ALHPA = ('A'..'Z').to_a
  ALLOWED_DIGITS = ('0'..'9').to_a

  attr_reader :name

  class << self
    attr_accessor :used_names

    def add_used_name(name)
      self.used_names << name
    end

    def remove_used_name(name)
      self.used_names.delete(name)
    end

    def used_names_reset
      self.used_names = []
    end
  end

  def initialize
    set_uniq_remove_from_used
  end

  def reset
    set_uniq_remove_from_used
  end

  def name_random
    name = ''
    NAME_ALPHA_NUMBER.times do |_|
      name << ALLOWED_ALHPA[rand(ALLOWED_ALHPA.size)]
    end
    NAME_DIGIT_NUMBER.times do |_|
      name << ALLOWED_DIGITS[rand(ALLOWED_DIGITS.size)]
    end
    name
  end

  def set_uniq_remove_from_used
    @name = name_random unless name

    new_name = name
    while used?(new_name)
      new_name = name_random
    end
    self.class.remove_used_name(name)
    @name = new_name
    self.class.add_used_name(name)
  end

  def used?(name)
    self.class.used_names.include? name
  end
end