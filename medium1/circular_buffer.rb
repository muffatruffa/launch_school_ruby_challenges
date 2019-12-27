class CircularBuffer
  class BufferEmptyException < StandardError; end
  class BufferFullException < StandardError; end

  def initialize(capacity)
    @capacity = capacity
    clear
  end

  def read
    raise BufferEmptyException unless @size > 0
    value = @buffer[@read_index]
    @buffer[@read_index] = nil
    increment_read_index
    @size -= 1
    value
  end

  def write(value)
    return if value.nil?
    raise BufferFullException if @size == @capacity
    @buffer[@write_index] = value
    increment_write_index
    @size += 1
  end

  def write!(value)
    begin
      write(value)
    rescue BufferFullException
      @read_index = (@read_index + 1) % @capacity if @read_index == @write_index
      @size -= 1
      retry
    end
  end

  def clear
    @size = 0
    @buffer = Array.new(@capacity)
    @read_index = 0
    @write_index = 0
  end

  private

  def increment_read_index
    @read_index = (@read_index + 1) % @capacity
  end

  def increment_write_index
    @write_index = (@write_index + 1) % @capacity
  end
end

if $PROGRAM_NAME == __FILE__
    buffer = CircularBuffer.new(2)
    buffer.write '1'
    buffer.read
    # buffer.write '2'
    # buffer.read
    p buffer

end