class OCRDigit
  def self.to_string_digit(text)
    case text
    when /\A\s_\s?\n\s*\|\s\|\s*\n\s*\|_\|\s*\n*\z/ then '0'
    when /\A\s*\n?\s\s\|\n\s\s\|\n*\z/ then '1'
    when /\A\s_\s?\n\s_\|\n\|_\s?\n*\z/ then '2'
    when /\A\s_\s?\n\s_\|\n\s_\|\n*\z/ then '3'
    when /\A\s*\n\|_\|\n\s\s\|\n*\z/ then '4'
    when /\A\s_\s?\n\|_\s?\n\s_\|\n*\z/ then '5'
    when /\A\s_\s?\n\|_\s?\n\|_\|\n*\z/ then '6'
    when /\A\s_\s?\n\s\s\|\n\s\s\|\n*\z/ then '7'
    when /\A\s_\s?\n\|_\|\n\|_\|\n*\z/ then '8'
    when /\A\s_\s?\n\|_\|\n\s_\|\n*\z/ then '9'
    else
      '?'
    end
  end
end

class OCRLine
  def initialize(text)
    @line_input = text
  end

  def to_string_digit
    digits.map { |ocr_digit| OCRDigit.to_string_digit(ocr_digit) }.join('')
  end

  private

  def input_rows
    @line_input.split(/\n/).map do |row|
      next ["\n"] if row.empty?
      row.split('')
    end
  end

  def rows_by_digit
    input_rows.map do |row|
      row.each_slice(3).reduce([]) { |result, ocr_row| result << ocr_row }
    end
  end

  def digits_rows
    rows_by_digit[0].zip(*rows_by_digit[1..-1])
  end

  def digits
    digits_rows.map do |ocr_character|
      ocr_character.map(&:join).join("\n")
    end
  end
end

class OCR
  attr_reader :ocr_text

  def initialize(text)
    @ocr_text = text
  end

  def convert
    ocr_lines.map do |ocr_line|
      ocr_line.to_string_digit
    end.join(',')
  end

  private

  def ocr_lines
    ocr_text.split(/\n\n/).map do |line|
      OCRLine.new(line)
    end
  end
end

if $PROGRAM_NAME == __FILE__
    text = <<-NUMBER.chomp
    _
  || |
  ||_|

NUMBER
  # ocr = OCR.new(text)
  # # p ocr.ocr_characters_in_lines
  # puts '***'
  # p ocr.convert

  # p ocr.split_lines_in_rows
  # /\A\s_\n\|\s\|\n\|_\|\n\z/
end
