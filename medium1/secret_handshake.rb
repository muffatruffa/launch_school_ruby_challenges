class SecretHandshake
  COMMANDS_NUMBER = 5
  COMMANDS = ['reverse', 'jump', 'close your eyes', 'double blink', 'wink']

  def initialize(secret_sequence)
    @binary_sequence = init_sequence(secret_sequence)
  end

  def commands
    operations_but_dropped = COMMANDS.drop(COMMANDS.size - @binary_sequence.size)
    @operations = operations_but_dropped.select.with_index do |operation, index|
      @binary_sequence[index] == '1' && operation != 'reverse'
    end
    operations
  end

  private

  def operations
    return @operations if @binary_sequence.size == COMMANDS_NUMBER && @binary_sequence[0] == '1'
    @operations.reverse
  end

  private

  def decimal_to_binary_sequence(decimal)
    /\A.*?([01]{,#{COMMANDS_NUMBER}})\z/.match(decimal.to_s(2))[1]
  end

  def init_sequence(secret_sequence)
    case secret_sequence
    when String
      if /\A[01]+\z/ =~ secret_sequence
        secret_sequence
      else
        ''
      end
    when Integer
      decimal_to_binary_sequence(secret_sequence)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  p sh = SecretHandshake.new(2).commands
end

