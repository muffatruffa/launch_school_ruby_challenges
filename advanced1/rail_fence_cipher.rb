class RailFenceCipher
  attr_reader :characters_board, :encode
  def initialize(text, rows_number)
    @text = text
    @rows_number = rows_number
    @characters_board = Array.new(rows_number) { Array.new }
    @encode ||= encode_text
  end


  def self.encode(text, rows_number)
    new(text, rows_number).encode
  end

  def self.decode(text, rows_number)
    new(text, rows_number).decode
  end


  def encode_text
    return @text if @rows_number < 2
    @characters_board[0][0] = @text[0]

    character_index = 1
    increment_index = -> do
      old = character_index
      character_index += 1
      old
    end
    loop do
      down_fill(increment_index)
      break if character_index >= @text.size

      up_fill(increment_index)
      break if character_index >= @text.size
    end
    characters_board_to_s
  end

  def text_to_encoded_board
    encrypted_characters = []
    encripted = @text
    @characters_board.each do |row|
      encrypted_characters << encripted[0..row.size - 1]
      encripted = encripted[row.size..-1]
    end
    encrypted_characters.map(&:chars)
  end

  def decode
    return @text if @rows_number < 2 || @text.empty?

    encrypted_characters = text_to_encoded_board
    decoded = encrypted_characters[0].shift
    loop do
      down_shift(encrypted_characters, decoded)
      break if encrypted_characters.all? { |row| row.empty?}

      up_shift(encrypted_characters, decoded)
      break if encrypted_characters.all? { |row| row.empty?}
    end
    decoded
  end

  def down_shift(encrypted_characters, decoded)
    (1..@rows_number - 1).each do |row|
      if encrypted_characters[row].empty?
        next
      end
      
      return if encrypted_characters.all? { |row| row.empty?}
      
      decoded << encrypted_characters[row].shift

    end
  end

  def up_shift(encrypted_characters, decoded)
    (@rows_number - 2).downto(0).each do |row|
      if encrypted_characters[row].empty?
        next
      end

      return if encrypted_characters.all? { |row| row.empty?}

      decoded << encrypted_characters[row].shift
    end
  end

  def up_fill(increment_index)
    (@rows_number - 2).downto(0).each do |row|
      character_index = increment_index.()
      
      return if character_index >= @text.size
      
      @characters_board[row] << @text[character_index]
    end
    nil
  end

  def  down_fill(increment_index)
    (1..@rows_number - 1).each do |row|
      character_index = increment_index.()

      return if character_index >= @text.size
      
      @characters_board[row] << @text[character_index]
    end
    nil
  end

  def characters_board_to_s
    @characters_board.map(&:join).join
  end
end

if $PROGRAM_NAME == __FILE__
  text = ('a'..'z').to_a.join
  # text = 'abc'
  rails_number = 3
  p text

  characters_board = Array.new(rails_number) { Array.new }
  characters_board[0] << text[0]
en = Enumerator.new do |y|
  character_index = 1
  until character_index == text.size
    (1..rails_number - 1).each do |row|
      break if character_index == text.size
      y << [character_index, row]
      character_index += 1
    end

    (rails_number - 2).downto(0).each do |row|
      break if character_index == text.size
      y << [character_index, row]
      character_index += 1
    end
  end
end


en.each { |character_index, row| characters_board[row] << text[character_index] }
p characters_board

end