class RailFenceCipher
  attr_reader :encode

  def initialize(text, rows_number)
    @text = text
    @rows_number = rows_number
    @characters_board = Array.new(@rows_number) { Array.new }
    @encode ||= encode_text
  end

  def self.encode(text, rows_number)
    new(text, rows_number).encode
  end

  def self.decode(text, rows_number)
    new(text, rows_number).decode
  end

  def rail_sequnce_enumerator
    Enumerator.new do |y|
      character_index = 1
      until character_index == @text.size
        (1..@rows_number - 1).each do |row|
          break if character_index == @text.size
          y << [character_index, row]
          character_index += 1
        end

        (@rows_number - 2).downto(0).each do |row|
          break if character_index == @text.size
          y << [character_index, row]
          character_index += 1
        end
      end
    end
  end


  def encode_text
    characters_board_reset
    return @text if @rows_number < 2 || @text.empty?

    @characters_board[0][0] = @text[0]
    rail_sequnce_enumerator.each do |character_index, row|
      @characters_board[row] << @text[character_index]
    end

    @characters_board.map(&:join).join
  end

  def characters_board_reset
    @characters_board = Array.new(@rows_number) { Array.new }
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

    rail_sequnce_enumerator.each do |_character_index, row|
      next if encrypted_characters[row].empty?
      decoded << encrypted_characters[row].shift
    end

    decoded
  end
end

if $PROGRAM_NAME == __FILE__
  c = RailFenceCipher.new('WECRLTEERDSOEEFEAOCAIVDEN', 3)
  p (c.decode == 'WEAREDISCOVEREDFLEEATONCE')
  # p c.encode

  text = 'WEAREDISCOVEREDFLEEATONCE'

  rails_number = 3


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


# en.each { |character_index, row| characters_board[row] << text[character_index] }
# p characters_board.map(&:join).join == 'WECRLTEERDSOEEFEAOCAIVDEN'

end