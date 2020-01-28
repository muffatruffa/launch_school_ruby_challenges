class Crypto
  def initialize(plain)
    @plain = plain
  end

  def normalize_plaintext
    @normalized ||= @plain.gsub(/[^\da-z]/i, '').downcase
  end

  def size
    current = 1
    while current * current < normalize_plaintext.size
      current += 1
    end
    current
  end

  def plaintext_segments
    normalize_plaintext.split('').each_slice(size).map(&:join)
  end

  def ciphertext
    normalize_ciphertext.gsub(/\s+/, '')
  end

  def normalize_ciphertext
    segments = plaintext_segments.map { |segment| segment.split('') }
    segments[0].zip(*segments[1..-1]).map { |colomn_segment| colomn_segment.join('') }.join(' ')
  end
end

if $PROGRAM_NAME == __FILE__
  crypto = Crypto.new('Never vex thine heart with idle woes')
  p crypto.plaintext_segments
  # crypto.normalize_plaintext

end