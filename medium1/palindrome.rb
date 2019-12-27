class Palindrome
  def initialize(candidate)
    @word = candidate
  end

  def palindrome?
    is_palindrome = true
    first = 0
    last = @word.size - 1
    while first < last
      first += 1 unless ('a'..'z').include? @word[first].downcase
      last -= 1 unless ('a'..'z').include? @word[last].downcase
      break is_palindrome = false unless @word[first].downcase == @word[last].downcase
      first += 1
      last -= 1
    end 
    is_palindrome
  end
end