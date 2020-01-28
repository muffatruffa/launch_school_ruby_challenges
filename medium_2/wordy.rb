class QueueBinaryEvaluator
  attr_accessor :operators, :operands, :result

  def initialize
    @operators = []
    @operands =[]
  end

  def evaluate(operators_mapper)
    until operands.empty?
      @result ||= operands.pop
      @result = operators_mapper.send(operators.pop, @result, operands.pop)
    end
    result
  end

  def add_operator(operator)
    @operators.unshift(operator)
  end

  def add_operand(operand)
    @operands.unshift(operand)
  end

end

class WordProblem
  attr_reader :evaluator

  def initialize(command)
    @command = command
    @evaluator = QueueBinaryEvaluator.new
  end

  def answer
    parse_command
    evaluator.evaluate(self)
  end

  def parse_command
    raise ArgumentError unless /-?\d.+-?\d/.match(@command)
    opeartors_operands = /-?\d.+-?\d/.match(@command)[0].split(' ')
    opeartors_operands.each do |to_parse|
      case to_parse
      when /-?\d/
        evaluator.add_operand(to_parse.to_i)
      when supported_operations
        evaluator.add_operator(to_parse.to_sym)
      end
    end
  end

  def plus(a, b)
    a + b
  end

  def minus(a,b)
    a - b
  end

  def multiplied(a, b)
    a * b
  end

  def divided(a,b)
    a / b
  end

  def supported_operations
    /plus|minus|multiplied|divided/
  end
end

if $PROGRAM_NAME == __FILE__
end