class ValueError < ::StandardError; end

class Board
  MINE_SYMBOL = '*'

  def self.transform(rows)
    new(rows).rows_to_s_plus_borders
  end

  attr_reader :mine_rows

  def initialize(mine_rows)
    @mine_rows = mine_rows

    raise ValueError unless valid?

    @board = to_a
    @row_count = @board.size
    @column_count = @board.first.size
  end

  def rows_to_s_plus_borders
    [@mine_rows.first ] + rows_to_s + [mine_rows.first]
  end

  private

  def rows_to_s
    board_with_mines_count.map do |row|
      "|#{row.join('').gsub('0',' ')}|"
    end
  end

  def to_a
    rows = mine_rows.select { |row| mine_row? row }
    rows.map { |row| row.scan(/[^|]/) }
  end

  def board_with_mines_count
    @board.map.with_index do |row, row_index|
      row.map.with_index do |character, column_index|
        next character if mine?(row_index, column_index) 
        count_adjacents_mines(row_index, column_index)
      end
    end
  end

  def count_adjacents_mines(row_index, column_index)
    adjacents_idexes(row_index, column_index).reduce(0) do |mine_count, adjacents|
      mine_count += 1 if mine?(*adjacents)
      mine_count
    end
  end

  def adjacents_idexes(row_index, column_index)
     indexes = [
      [row_index - 1, column_index - 1],
      [row_index - 1, column_index],
      [row_index - 1, column_index + 1],
      [row_index, column_index -1],
      [row_index, column_index + 1],
      [row_index + 1, column_index - 1],
      [row_index + 1, column_index],
      [row_index + 1, column_index + 1]
    ]
    indexes.select do |row_ind, column_ind|
      ((0...@row_count).include? row_ind) &&
      ((0...@column_count).include? column_ind)
    end
  end


  def mine_row?(row)
    row.match(/\A\|[\s*]+\|\z/)
  end

  def mine?(row_index, column_index)
    @board[row_index][column_index] == MINE_SYMBOL
  end

  def valid?
    valide_borders = [mine_rows.first, mine_rows.last].all? do |row|
      row =~ /\A\+-+\+\z/
    end

    valide_rows = mine_rows[1...-1].all? do |row|
      row =~ /\A\|[ *]+\|\z/
    end

    
    size = mine_rows.first.size
    all_same_size = mine_rows.all? do |row|
      size == row.size
    end
    
    valide_borders && valide_rows && all_same_size
  end
end

if $PROGRAM_NAME == __FILE__
  inp = ['+------+', '| *  * |', '|  *   |', '|    * |', '|   * *|',
    '| *  * |', '|      |', '+------+']
  b = Board.new(inp)

  p(b.board_with_mines_count)

end