class Triangle
  def initialize(rows_number)
    @rows_number = rows_number
  end

  def rows
    result = [[1]]
    return result if @rows_number == 1

    (1..(@rows_number -1)).each do |row_index|
      result << []
      (0..row_index).each do |number_index|
        previous_row = result[row_index-1]
        if number_index == 0 || number_index == row_index
          result.last << 1
        else
          result.last << previous_row[number_index - 1] + previous_row[number_index]
        end
      end
    end
    result
  end

  # recursive solution with ruby's built in methods #each_cons and #map
  # def rows
  #   rec_rows = ->(n) do
  #     if n == 1
  #       [[1]]
  #     else
  #       previous_row = rec_rows.(n-1)
  #       previous_row << [1] + previous_row.last.each_cons(2).map {|left, right| left + right} + [1]
  #     end
  #   end
  #   rec_rows.(@rows_number)
  # end

  #recursive solution without ruby's built in methods
  # def rows
  #   row_from_previous = ->(previous, result) do
  #     if previous.size == 1
  #       [1] + result + [1]
  #     else
  #       result << (previous[0] + previous[1])
  #       row_from_previous.(previous[1..-1], result)
  #     end
  #   end
 
  #   rec_rows = ->(n, result) do
  #     if n == 1
  #       result
  #     else
  #       result << row_from_previous.(result.last, [])
  #       rec_rows.(n-1, result)
  #     end
  #   end

  #   rec_rows.(@rows_number, [[1]])
  # end
end

if $PROGRAM_NAME == __FILE__
  # t = Triangle.new(5)
  # p t
  # p t.rows

  row_from_previous = ->(previous, result) do
    if previous.size == 1
      [1] + result + [1]
    else
      result << (previous[0] + previous[1])
      row_from_previous.(previous[1..-1], result)
    end
  end
p row_from_previous.([[1]], [])
p row_from_previous.([1, 1], [])
p row_from_previous.([1, 2, 1], [])




end