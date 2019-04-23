# # White Knight
# p "\u2658".encode('utf-8')

# # Black Knight
# p "\u265E".encode('utf-8')

$: << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'chessboard'

class Knight
  attr_reader :piece, :starting_positions

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
    generate_all_knight_moves
  end

  def all_possible_moves
    @starting_positions
  end

  def generate_all_knight_moves
    (0..63).each do |n|
      generate_knight_left_moves(n)
      generate_knight_right_moves(n)
    end
  end

  private
  def generate_knight_left_moves(n)
    add_knight_node(n, 17) if n % 8 < 7 && starting_positions[n].coordinates[1] <= 6 # Up right moves (2 up 1 right)
    add_knight_node(n, 10) if n % 8 < 6 && starting_positions[n].coordinates[1] <= 7 # Up right moves (1 up 2 right)
    add_knight_node(n, -6) if n % 8 < 6 && starting_positions[n].coordinates[1] >= 2  # Down right moves (1 down 2 right)
    add_knight_node(n, -15) if n % 8 < 7 && starting_positions[n].coordinates[1] >= 3 # Down right moves (2 down 1 right)
  end

  def generate_knight_right_moves(n)
    add_knight_node(n, 15) if n % 8 > 0 && starting_positions[n].coordinates[1] <= 6 # Up left moves (2 up 1 left)
    add_knight_node(n, 6) if n % 8 > 1 && starting_positions[n].coordinates[1] <= 7 # Up left moves (1 up 2 left)
    add_knight_node(n, -10) if n % 8 > 1 && starting_positions[n].coordinates[1] >= 2  # Down left moves (1 down 2 left)
    add_knight_node(n, -17) if n % 8 > 0 && starting_positions[n].coordinates[1] >= 3  # Down left moves (2 down 1 left)
  end

  def add_knight_node(n, shift_factor)
    starting_positions[n].possible_moves << n + shift_factor
  end
end

knight = Knight.new("\u2658".encode('utf-8'))
p knight.starting_positions