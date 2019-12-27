class DNA
  def initialize(this_dna)
    @dna = this_dna
  end

  def hamming_distance(other_dna)
    distance = 0
    (0...shorter_size(other_dna)).each do |index|
      next if @dna[index] == other_dna[index]
      distance += 1
   end
    distance
  end

  def shorter_size(other_dna)
    other_dna.size < @dna.size ? other_dna.size : @dna.size
  end
end
