# Problem description:
# given a number 735291
# if you rotate to the left you get 352917
# keep first in place and rotate remaining 329175
# keep first 2 in place and rotate remaining 321759
# keep first 3 in place and rotate remaining 321597
# keep first 4 in place and rotate remaining 321579
# The result is called the maximum rotation of the original number

# Write a method max_rotation that take an integers and returns the maximum rotation.

def max_rotation(n)
  digits_string = n.to_s.chars
  (0...digits_string.size - 1).each {|index| rotate_at(digits_string, index)}
  drop_leading_values(digits_string, '0').join.to_i
end

def rotate_at(collection, n)
  collection << collection.delete_at(n)
end

def drop_leading_values(collection, value)
  current_index = collection.size - 1
  while collection[current_index] == value && current_index >= 0
    collection.delete_at(current_index)
    current_index -= 1
  end
  collection
end

def max_rotation(n)
  digits_string = n.to_s.chars

  rotate = ->(digits, rotated) do
    if digits.size == 1
      rotated << digits.first
    else
      rotate.(digits[2..-1] << digits[0], rotated << digits[1])
    end
  end

  /^([\d]*[1-9])0*$/.match(rotate.(digits_string, ''))[1].to_i
end

p max_rotation(735291)
p max_rotation(3)
p max_rotation(35)
p max_rotation(105)
p max_rotation(8_703_529_146)
