# class House
#   def self.recite
#     new.all_song

#   end

#   def all_song
#     @song ||= build_song
#   end

#   private

#   def build_song
#     song = ''
#     song.prepend("#{verses_from_pieces(0)}\n")

#     1.upto(pieces.size - 1).each do |row_index|
#       song.prepend("#{verses_from_pieces(row_index)}\n\n")
#     end
#     song
#   end

#   def verses_from_pieces(starting_index)
#     verses = "This is #{pieces[starting_index][0]}\n"
#     (starting_index + 1...pieces.size).each do |piece_index|
#       verses << "#{pieces[piece_index - 1][1]} #{pieces[piece_index][0]}\n"
#     end
#     "#{verses.chomp}."
#   end

#   def pieces
#     [
#       ['the horse and the hound and the horn', 'that belonged to'],
#       ['the farmer sowing his corn', 'that kept'],
#       ['the rooster that crowed in the morn', 'that woke'],
#       ['the priest all shaven and shorn', 'that married'],
#       ['the man all tattered and torn', 'that kissed'],
#       ['the maiden all forlorn', 'that milked'],
#       ['the cow with the crumpled horn', 'that tossed'],
#       ['the dog', 'that worried'],
#       ['the cat', 'that killed'],
#       ['the rat', 'that ate'],
#       ['the malt', 'that lay in'],
#       ['the house that Jack built']
#     ]
#   end
# end

# require 'pry'
# class House
#   def self.recite
#     new.all_song
#   end

#   def all_song
#     @song ||= build_song
#   end

#   private

#   def build_song
#     build_all = ->(verses, final_song) do
#       if verses.empty?
#         "#{final_song}"
#       else
#         final_song.prepend "#{sing_till_end(verses)}\n"
#         build_all.(verses[1..-1], final_song)
#       end
#     end
    
#     build_all.(pieces, '').chomp
#   end

#   def sing_till_end(verses)
#     verses_to_end = ->(verses, final_verses) do
#       if verses.empty?
#         "This is #{final_verses}".strip.chomp + ".\n"
#       else
#         final_verses << "#{verses[0][0]}\n#{verses[0][1]} "
#         verses_to_end.(verses[1..-1], final_verses)
#       end
#     end
#     verses_to_end.(verses, '')
#   end

#   def pieces
#     [
#       ['the horse and the hound and the horn', 'that belonged to'],
#       ['the farmer sowing his corn', 'that kept'],
#       ['the rooster that crowed in the morn', 'that woke'],
#       ['the priest all shaven and shorn', 'that married'],
#       ['the man all tattered and torn', 'that kissed'],
#       ['the maiden all forlorn', 'that milked'],
#       ['the cow with the crumpled horn', 'that tossed'],
#       ['the dog', 'that worried'],
#       ['the cat', 'that killed'],
#       ['the rat', 'that ate'],
#       ['the malt', 'that lay in'],
#       ['the house that Jack built']
#     ]
#   end
# end


class House
  def self.recite
    new.recite
  end

  def recite
    @song ||= song
  end


  def n_verses(character, composed)
    return "#{composed}." if character == :stop
  
    case character
    when :horse
      composed << "the horse and the hound and the horn\nthat belonged to "
      n_verses(:farmer, composed)
    when :farmer
      composed << "the farmer sowing his corn\nthat kept "
      n_verses(:rooster, composed)
    when :rooster
      composed << "the rooster that crowed in the morn\nthat woke "
      n_verses(:priest, composed)
    when :priest
      composed << "the priest all shaven and shorn\nthat married "
      n_verses(:man, composed)
    when :man
      composed << "the man all tattered and torn\nthat kissed "
      n_verses(:maiden, composed)
    when :maiden
      composed << "the maiden all forlorn\nthat milked "
      n_verses(:cow, composed)
    when :cow
      composed << "the cow with the crumpled horn\nthat tossed "
      n_verses(:dog, composed)
    when :dog
      composed << "the dog\nthat worried "
      n_verses(:cat, composed)
    when :cat
      composed << "the cat\nthat killed "
      n_verses(:rat, composed)
    when :rat
      composed << "the rat\nthat ate "
      n_verses(:malt, composed)
    when :malt
      composed << "the malt\nthat lay in "
      n_verses(:house, composed)
    when :house
      composed << "the house that Jack built"
      n_verses(:stop, composed)
    else
      raise ArgumentError
    end
  end

  
  def song
    sequence = [:horse, :farmer, :rooster, 
      :priest, :man, :maiden, :cow, :dog, :cat, :rat, :malt, :house ]
    all = ''
    sequence.each do |character_symbol|
      all.prepend "#{n_verses(character_symbol, "This is ")}\n\n"
    end
    all.chomp
  end
end

if $PROGRAM_NAME == __FILE__
h = House.new
puts h.song

end