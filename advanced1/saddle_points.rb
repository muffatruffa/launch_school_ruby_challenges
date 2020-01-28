class Matrix
  def initialize(line_separeted_mtrix)
    @data = self.class.matrix(line_separeted_mtrix)
    @rows_length = @data.size
    @columns_length = @data.first.size
  end

  def rows
    @data.dup
  end

  def columns
    @data.dup.transpose
  end

  def saddle_points
    saddles = []
    0.upto(@rows_length - 1) do |row_index|
      0.upto(@data[row_index].size - 1) do |column_index|
        saddles << [row_index, column_index] if saddle?(row_index, column_index)
      end 
    end
    saddles
  end

  def saddle?(row_index, column_index)
    rows[row_index].max == @data[row_index][column_index] &&
    columns[column_index].min == @data[row_index][column_index]
  end

  def self.matrix(data)
    case data
    when String
      data.split("\n").map do |row_string|
        row_string.split(" ").map(&:to_i)
      end
    when Array
      data
    end
  end
end

if $PROGRAM_NAME == __FILE__
  matrix = Matrix.new("1 2\n10 20")
  p matrix.rows[0]
end