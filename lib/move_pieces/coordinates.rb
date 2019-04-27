module Coordinates
  LETTERS = %w(a b c d e f g h)

  def generate_coordinates(n, l)
    l + n.to_s
  end

  def convert_coordinates_to_num(coordinate)
    (coordinate[1].to_i - 1) * 8 + LETTERS.index(coordinate[0])
  end

  def convert_num_to_coordinates(num)
    n = (num / 8) + 1
    l = LETTERS[num % 8]
    generate_coordinates(n, l)
  end

  def valid_coordinate?(coordinate)
    return false unless LETTERS.one? { |l| l == coordinate[0] } && (1..8).include?(coordinate[1].to_i)
    return false if coordinate.length > 2
    true if LETTERS.one? { |l| l == coordinate[0] } && (1..8).include?(coordinate[1].to_i)
  end
end