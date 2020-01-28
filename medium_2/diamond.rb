class Diamond
  def self.make_diamond(base_letter)
    (top_to_base(base_letter) +
    bottom(base_letter)).join('')
  end

  def self.diamond_base_size(letter)
    (2 * (up_side_letters(letter).size - 1)) + 1
  end

  def self.up_side_letters(letter)
    ('A'..letter).to_a
  end

  def self.row_except_triangles(base_letter)
    up_side_letters(base_letter).map do |letter|
      next "#{letter}" if letter == 'A'
      "#{letter}" \
      "#{' ' * ((up_side_letters(base_letter).index(letter) * 2) - 1)}" \
      "#{letter}"
    end
  end

  def self.top_to_base(base_letter)
    row_except_triangles(base_letter).map do |core_diamond|
      n_spaces = diamond_base_size(base_letter) - core_diamond.size
      (" " * (n_spaces  / 2)) +
      core_diamond +
      (" " * (n_spaces  / 2)) +
      "\n"
    end
  end

  def self.bottom(base_letter)
    row_except_triangles(base_letter)[0..-2].map do |core_diamond|
      n_spaces = diamond_base_size(base_letter) - core_diamond.size
      (" " * (n_spaces  / 2)) +
      core_diamond +
      (" " * (n_spaces  / 2)) +
      "\n"
    end.reverse
  end
end

if $PROGRAM_NAME == __FILE__
  puts Diamond.make_diamond('A')
  puts Diamond.make_diamond('B')
  puts Diamond.make_diamond('C')
  puts Diamond.make_diamond('E')

end