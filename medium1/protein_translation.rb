class RnaStrand
  attr_reader :codons

  def initialize(sequence)
    @codons = codons_from_sequence(sequence)
    @protein_mapper = AminoAcids
  end

  def to_protein_or_stop
    protein_mapper.protein_for_codon(codons.first)
  end

  def to_proteins
    all = codons.map do |codon|
      protein_mapper.protein_for_codon(codon)
    end
    all.take_while { |protein| protein != 'STOP'}
  end

  def valid?
    codons.all? do |codon|
      protein_mapper.valid_codon?(codon)
    end
  end

  private

  attr_reader :protein_mapper

  def codons_from_sequence(sequence)
    sequence.split('').each_slice(3).map { |codon| codon.join('') }
  end
end

class AminoAcids
  Protein = Struct.new(:name, :codons) do
    def translation_of?(codon)
      codons.include? codon
    end
  end

  @proteins = []
  @proteins << Protein.new('Methionine', %w(AUG))
  @proteins << Protein.new('Phenylalanine', %w(UUU UUC))
  @proteins << Protein.new('Leucine', %w(UUA UUG))
  @proteins << Protein.new('Serine', %w(UCU UCC UCA UCG))
  @proteins << Protein.new('Tyrosine', %w(UAU UAC))
  @proteins << Protein.new('Cysteine', %w(UGU UGC))
  @proteins << Protein.new('Tryptophan', %w(UGG))
  @proteins << Protein.new('STOP', %w(UAA UAG UGA))

  def self.all
    @proteins
  end

  def self.valid_codon?(codon)
    @proteins.any? { |protein| protein.translation_of?(codon) }
  end

  def self.protein_for_codon(codon)
    all.select { |protein| protein.translation_of?(codon)}.first.name
  end
end

class InvalidCodonError < RuntimeError; end

class Translation
  attr_reader :protein, :proteins

  def initialize(rna)
    raise InvalidCodonError unless rna.valid?
    @rna = rna
    @protein = @rna.to_protein_or_stop
    @proteins = @rna.to_proteins
  end

  def self.of_codon(codon)
    new(RnaStrand.new(codon)).protein
  end

  def self.of_rna(sequence)
    new(RnaStrand.new(sequence)).proteins
  end
end
class InvalidCodonError < RuntimeError; end

class Translation
  def self.of_codon(codon)
    case codon
    when /AUG/ then 'Methionine'
    when /UU[UC]/ then 'Phenylalanine'
    when /UU[AG]/ then 'Leucine'
    when /UC[UCAG]/ then 'Serine'
    when /UA[UC]/ then 'Tyrosine'
    when /UG[UC]/ then 'Cysteine'
    when /UGG/ then 'Tryptophan'
    when /UA[AG]|UGA/ then 'STOP'
    else raise InvalidCodonError
    end
  end

  def self.of_rna(sequence)
    proteins_from_rna = ->(sequence, proteins) do
      case sequence
      when '' then proteins
      else
        protein = of_codon(sequence[0..2])
        case protein
        when 'STOP' then proteins
        else
          proteins_from_rna.(sequence[3..-1], proteins << protein)
        end
      end
    end
    proteins_from_rna.(sequence, [])
  end
end



if $PROGRAM_NAME == __FILE__

end