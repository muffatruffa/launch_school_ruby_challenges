class Robot
  attr_reader :position

  def initialize
    @position = OrientedPoint.new
  end

  def place(x, y, direction)
    at(x,y)
    orient(direction)
    self
  end

  def orient(direction)
    @position.orient(direction)
  end

  def bearing
    @position.bearing
  end

  def turn_right
    @direction = position.turn_right
  end

  def turn_left
    @direction = position.turn_left
  end

  def at(x, y)
    @position.coordinates = [x, y]
  end

  def coordinates
    @position.coordinates
  end

  def advance
    @position.move
  end
end

class Direction
  def to_sym
    self.class.name.downcase.to_sym
  end
end

class North < Direction
  def right
    East.new
  end

  def left
    West.new
  end

  def cartesian_factor
    {x: 0, y: 1}
  end
end

class South < Direction
  def right
    West.new
  end

  def left
    East.new
  end

  def cartesian_factor
    {x: 0, y: -1}
  end
end

class East < Direction
  def right
    South.new
  end

  def left
    North.new
  end

  def cartesian_factor
    {x: 1, y: 0}
  end
end

class West < Direction
  def right
    North.new
  end

  def left
    South.new
  end

  def cartesian_factor
    {x: -1, y: 0}
  end
end

class OrientedPoint
  DIRECTIONS = [:east, :west, :north, :south]

  attr_reader :direction
  attr_accessor  :x, :y

  def initialize(x: 0, y: 0, direction: North.new)
    @x = x
    @y = y
    @direction = direction
  end

  def orient(direction_sym)
    raise ArgumentError unless DIRECTIONS.include? direction_sym
    @direction = Module.const_get(direction_sym.to_s.capitalize).new
  end

  def turn_right
    @direction = direction.right
  end

  def turn_left
    @direction = direction.left
  end

  def bearing
    @direction.to_sym
  end

  def coordinates=(x_y)
    @x = x_y.first
    @y = x_y.last
  end

  def coordinates
    [@x, @y]
  end

  def move
    @x = @x + (1 * direction.cartesian_factor[:x])
    @y = @y + (1 * direction.cartesian_factor[:y])
  end
end

class Simulator
  def instructions(moves_sequence)
    instructions_evaluator = ->(moves_sequence, collection) do
      case moves_sequence
      when ""
        collection
      when "L"
        collection << :turn_left
      when "R"
        collection << :turn_right
      when "A"
        collection << :advance
      else
        instructions_evaluator.(moves_sequence[0], collection)
        instructions_evaluator.(moves_sequence[1..-1], collection)
      end
    end
    instructions_evaluator.(moves_sequence, [])
  end

  def place(robot, x:, y:, direction:)
    robot.place(x, y, direction)
  end

  def evaluate(robot, moves_sequence)
    instructions(moves_sequence).each do |instruction|
      robot.send(instruction)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  s = Simulator.new
  s.instructions('L')
end