class Cipher
  attr_reader :key

  def initialize(key = nil)
    @key = set_key(key)
  end

  def encode(plain_text)
    encoded = ''
    map_text_to_key(plain_text) do |chracter, encode_key|
      encoded << encode_character(chracter, encode_key)
    end
    encoded
  end


  def decode(plain_text)
    decoded = ''
    map_text_to_key(plain_text) do |chracter, decode_key|
      decoded << decode_character(chracter, decode_key)
    end
    decoded
  end

  private

  def random_key
    r_key = ''
    100.times do |_|
      r_key << (rand('a'.ord..'z'.ord)).chr
    end
    r_key
  end

  def encode_character(character, key)
    shift = key.ord - 'a'.ord
    chracter_ord_a_at0 = character.ord - 'a'.ord
    encoded = 'a'.ord + ((chracter_ord_a_at0 + shift) % alphabet_size)
    encoded.chr
  end

  def decode_character(encoded_character, key)
    shift = key.ord - 'a'.ord
    chracter_ord_a_at0 = encoded_character.ord - 'a'.ord
    decoded = 'a'.ord + ((chracter_ord_a_at0 - shift) % alphabet_size)
    decoded.chr
  end

  def map_text_to_key(plain_text)
    chracter_index = 0
    while chracter_index <= plain_text.size - 1
      character = plain_text[chracter_index]
      chracter_key = key[chracter_index % key.size]
      yield(character, chracter_key)
      chracter_index += 1
    end
  end

  def alphabet_size
    ('a'..'z').to_a.size
  end

  def set_key(key)
    return random_key if key.nil?
    raise(ArgumentError, "#{key} is not a valide key") if /[^a-z]|\A\z/ =~ key
    @key = key
  end
end

if $PROGRAM_NAME == __FILE__
  @cipher = Cipher.new("aaab")
  p @cipher.encode("iamapandabear") == "iambpaneabebr"
end