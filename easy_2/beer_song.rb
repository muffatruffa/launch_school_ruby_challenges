# class BeerSongVerse
#   def at(verse_number)
#     case verse_number
#     when 0 then zero_beer
#     when 1 then one_beer
#     when 2 then two_beer
#     else reapeted_verse(verse_number)
#     end
#   end

#   def from_to(from,to)
#     from.downto(to).map {|verse_number| "#{at(verse_number)}"}.join("\n")
#   end

#   private

#   def zero_beer
#     "No more bottles of beer on the wall, no more bottles of beer.\n" \
#     "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
#   end

#   def one_beer
#     "1 bottle of beer on the wall, 1 bottle of beer.\n" \
#     "Take it down and pass it around, no more bottles of beer on the wall.\n" \
#   end

#   def two_beer
#     "2 bottles of beer on the wall, 2 bottles of beer.\n" \
#     "Take one down and pass it around, 1 bottle of beer on the wall.\n"
#   end

#   def reapeted_verse(verse_number)
#     "#{verse_number} bottles of beer on the wall, #{verse_number} bottles of beer.\n" \
#     "Take one down and pass it around, #{verse_number - 1} bottles of beer on the wall.\n"
#   end
# end

class BeerSongVerse
  attr_reader :beers_number, :verse_number, :verse

  ENUM_SIZE = 100
  MAX_BEER_BOTTLES = 99

  ENUM_VERSE = Enumerator.new do |y|
    MAX_BEER_BOTTLES.downto(3) do |beers_number|
      y << reapeted_verse(beers_number)
    end
    y << two_beer
    y << one_beer
    y << zero_beer
  end

  def self.zero_beer
    "No more bottles of beer on the wall, no more bottles of beer.\n" \
    "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
  end

  def self.one_beer
    "1 bottle of beer on the wall, 1 bottle of beer.\n" \
    "Take it down and pass it around, no more bottles of beer on the wall.\n" \
  end

  def self.two_beer
    "2 bottles of beer on the wall, 2 bottles of beer.\n" \
    "Take one down and pass it around, 1 bottle of beer on the wall.\n"
  end

  def self.reapeted_verse(number_of_beers)
    "#{number_of_beers} bottles of beer on the wall, #{number_of_beers} bottles of beer.\n" \
    "Take one down and pass it around, #{number_of_beers - 1} bottles of beer on the wall.\n"
  end

  def at(number_of_beers)
    number_of_beers = number_of_beers % ENUM_SIZE

    build_verse(number_of_beers)
    verse
  end

  def from_to(from,to)
    from.downto(to).map {|number_of_beers| at(number_of_beers) }.join("\n")
  end

  private

  def beer_enum
    yield(ENUM_VERSE)
    ENUM_VERSE.rewind
  end

  def build_verse(number_of_beer)
    @beers_number = number_of_beer
    @verse_number = ENUM_SIZE - beers_number
    beer_enum { |enum| verse_number.times {|_| @verse = enum.next }}
  end
end

class BeerSong
  def initialize
    @verse = BeerSongVerse.new
  end

  def verse(number)
    @verse.at(number)
  end

  def verses(from, to)
    @verse.from_to(from, to)
  end

  def lyrics
    verses(99,0)
  end
end

if $PROGRAM_NAME == __FILE__
  puts BeerSong.new.verses(2, 0)
  puts BeerSong.new.verse(100)
end