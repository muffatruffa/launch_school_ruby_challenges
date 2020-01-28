class Element
  attr_accessor :datum, :next
  def initialize(datum, next_element = nil)
    @datum = datum
    @next = next_element
  end

  def tail?
    !@next
  end
end

class SimpleLinkedList
  attr_reader :head, :size

  def initialize
    @size = 0
  end

  def empty?
    @size == 0
  end

  def push(item)
    @head = Element.new(item, head)
    @size += 1
  end

  def peek
    return nil unless @head
    @head.datum
  end

  def pop
    return if empty?
    @size -= 1
    previuos_head = @head
    datum = peek
    @head = @head.next
    # should speed up garbage collection
    previuos_head = nil
    datum
  end

  def self.from_a(collection)
    return new() if Array(collection).empty?

    list = new()
    (collection.size - 1).downto(0) { |index| list.push(collection[index]) }
    list
  end

  def to_a
    return [] if empty?

    fill_array = ->(element, result) do
      result << element.datum
      if element.tail?
        return result
      else
        fill_array.(element.next, result)
      end
    end

    fill_array.(@head, [])
  end

  def tail(list)
    return if list.empty?
    tl = self.class.new
    tl.head = list.head.next
    tl.size = list.size - 1
    tl
  end


  def reverse
    reversed = self.class.new
    current = self

    loop do
      reversed.push(current.peek)
      current = tail(current)

      break if current.head.tail?
    end
    reversed.push(current.peek)

    reversed
  end

  protected
  attr_writer :head, :size

  private :tail
end

if $PROGRAM_NAME == __FILE__
   list = SimpleLinkedList.from_a([1, 2, 3, 4])
   p list
   puts
   list_r = list.reverse
   p list_r
end