class Queens
  WHITE_COLOR = 'W'
  BLACK_COLOR = 'B'

  def initialize(white: [0, 3], black: [7, 3])
    raise ArgumentError if black == white
    @white = Queen.new(*white, WHITE_COLOR)
    @black = Queen.new(*black, BLACK_COLOR)
    @chessboard = ChessBoard.new
    @chessboard.place_pieces([@white, @black])
  end

  def white
    [@white.row, @white.column]
  end

  def black
    [@black.row, @black.column]
  end

  def to_s
    @chessboard.to_s
  end

  def attack?
    includes_queen?(@black, @chessboard.row_where(@white)) ||
    includes_queen?(@black, @chessboard.column_where(@white)) ||
    includes_queen?(@black, @chessboard.diagonals_where(@white))
  end

  private

  def includes_queen?(queen, board_squares)
    board_squares.any? do |square|
      square == queen
    end
  end
end

class Queen
  attr_reader :row, :column, :color

  def initialize(row, column, color)
    @row = row
    @column = column
    @color = color
  end

  def to_s
    color
  end

  def ==(other)
    other.kind_of?(Queen) &&
    other.color == color
  end
end

class ChessBoard
  BOARD_SIZE = 8

  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE)}
  end

  def place_pieces(pieces)
    pieces.each do |piece|
      @board[piece.row][piece.column] = piece
    end
  end

  def to_s
    @board.map do |row|
      row.map do |item|
        next "#{emtpy_cell_character}" if item.nil?
        "#{item.to_s}"
      end.join(" ")
    end.join("\n")
  end

  def row_where(piece)
    @board[piece.row]
  end

  def column_where(piece)
    column_index = piece.column
    column = []
    (0...BOARD_SIZE).each do |row_index|
      column << @board[row_index][column_index]
    end

    column
  end

  def diagonals_where(piece)
    main_diagonal_at(piece.row, piece.column) +
    secondary_diagonal_at(piece.row, piece.column)
  end

  private

  def emtpy_cell_character
    '_'
  end

  def main_diagonal_at(row,column)
    diagonal = []
    diagonal_column = column
    row.upto(BOARD_SIZE - 1) do |diagonal_row|
      break if diagonal_column >= BOARD_SIZE
      diagonal << @board[diagonal_row][diagonal_column]
      diagonal_column += 1
    end

    diagonal_column = column - 1
    (row - 1).downto(0).each do |diagonal_row|
      break if diagonal_column < 0
      diagonal << @board[diagonal_row][diagonal_column]
      diagonal_column -= 1
    end

    diagonal
  end

  def secondary_diagonal_at(row, column)
    diagonal = []
    diagonal_column = column
    row.downto(0) do |diagonal_row|
      break if diagonal_column >= BOARD_SIZE
      diagonal << @board[diagonal_row][diagonal_column]
      diagonal_column += 1
    end

    diagonal_column = column - 1
    (row + 1).upto(BOARD_SIZE - 1) do |diagonal_row|
      break if diagonal_column < 0
      diagonal << @board[diagonal_row][diagonal_column]
      diagonal_column -= 1
    end

    diagonal
  end
end

if $PROGRAM_NAME == __FILE__
  queens = Queens.new(white: [2, 4], black: [6, 6])
  # puts queens.to_s
  c = ChessBoard.new
  p c.main_diagonal_at(2,3)
end