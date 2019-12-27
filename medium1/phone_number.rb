class PhoneNumber
  InvalidNumber = Struct.new(:phone_number) do
    def number
      '0' * 10
    end
  end

  ElevenNumber = Struct.new(:phone_number) do
    def number
      phone_number.scan(/\d/).join('')[1..-1]
    end
  end

  TenNumber = Struct.new(:phone_number) do
    def number
      phone_number.scan(/\d/).join('')
    end
  end

  attr_reader :number

  def initialize(phone_number)
    @phone_number = phone_number
    @parser = parser().new(@phone_number)
    @number = @parser.number
  end

  def area_code
    number[0..2]
  end

  def to_s
    not_formatted = number
    "(#{not_formatted[0..2]}) #{not_formatted[3..5]}-#{not_formatted[6..-1]}"
  end

  def parser
    return InvalidNumber unless valid?

    case @phone_number.scan(/\d/).size
    when 10
      TenNumber
    when 11
      ElevenNumber
    end
  end

  def valid?
    return false if /[^\d\.\-\(\) ]/ =~ @phone_number
    numbers = @phone_number.scan(/\d/)
    numbers.size == 10 || (numbers.size == 11 && numbers[0] == '1')
  end
end

if $PROGRAM_NAME == __FILE__
  p PhoneNumber.new('(13) 45-78905')
end