# class RunLengthEncoding
#   def self.encode(plain_text)
#     self.count_characters(plain_text).map do |(letter, count)|
#       leading = count == 1 ? '' : count.to_s
#       "#{leading}#{letter}"
#     end.join('')
#   end

#   def self.decode(encoded)
#     encoded.gsub(/(\d+)([^\d]{1})/i) { |encoded_letter| $2 * $1.to_i }
#   end

#   def self.count_characters(text)
#     characters = text.split('')
#     letters_count = [[characters[0], 1]]
#     (1..characters.size - 1).each do |next_index|
#       if characters[next_index - 1] == characters[next_index]
#         letters_count.last[1] += 1
#       else
#         letters_count << [characters[next_index], 1]
#       end
#     end
#     letters_count
#   end
# end
module ConsecutiveCounter
  module_function

  def Counter(data)
      counter = Counter.new(data.to_a)
      counter.add_new(data[0])
      counter
  end

  Counter = Struct.new(:data, :count) do
    # Return an array of pairs ([object_item_in_data, number_of_consecutive_object])
    # given data = [1, 1, 1, 1, 3, 1, 6, 2, 2, 2] -> [[1,4], [3, 1], [1, 1], [6, 1], [2, 3]]
    def count_items
      (1..data.size - 1).each do |next_index|
        if data[next_index - 1] == data[next_index]
          increment_count
        else
          add_new(data[next_index])
        end
      end
      count
    end

    def add_new(data_item)
      self.count = [] unless count
      self.count << [data_item, 1]
    end

    def increment_count
      self.count.last[1] += 1
    end
  end
end

class RunLengthEncoding
  include ConsecutiveCounter

  attr_reader :counter

  def initialize(data)
    @counter = Counter(data)
  end


  def self.encode(plain_text)
    self.count_characters(plain_text).map do |(letter, count)|
      leading = count == 1 ? '' : count.to_s
      "#{leading}#{letter}"
    end.join('')
  end

  def self.decode(encoded)
    encoded.gsub(/(\d+)([^\d]{1})/i) { |encoded_letter| $2 * $1.to_i }
  end

  def self.count_characters(text)
    characters = text.split('')
    letters_counter = new(characters).counter
    letters_counter.count_items
  end
end

if $PROGRAM_NAME == __FILE__
  p RunLengthEncoding.Counter([1, 1, 3])
end