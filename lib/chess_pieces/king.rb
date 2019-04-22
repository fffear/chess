# # White King
# p "\u2654".encode('utf-8')

# # Black King
# p "\u265A".encode('utf-8')

$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'generate_moves'

class King
  attr_reader :piece, :starting_positions, :original_position
  attr_accessor :move_count

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
    @move_count = 0
  end

  def generate_moves
    (0...64).each do |n|
      generate_horizontal_moves(n)
      generate_vertical_moves(n)
      generate_up_right_moves(n)
      generate_up_left_moves(n)
    end
  end

  def all_possible_moves
    @starting_positions
  end

  private
  def generate_horizontal_moves(n)
    @starting_positions[n].possible_moves << @starting_positions[n + 1].coordinates if n % 8 != 7
    @starting_positions[n].possible_moves << @starting_positions[n - 1].coordinates if n % 8 != 0
  end

  def generate_vertical_moves(n)
    @starting_positions[n].possible_moves << @starting_positions[n + 8].coordinates if n < 56
    @starting_positions[n].possible_moves << @starting_positions[n - 8].coordinates if n > 7
  end

  def generate_up_right_moves(n)
    @starting_positions[n].possible_moves << @starting_positions[n + 9].coordinates if n % 8 != 7 && n < 56
    @starting_positions[n].possible_moves << @starting_positions[n - 9].coordinates if n % 8 != 0 && n > 7
  end

  def generate_up_left_moves(n)
    @starting_positions[n].possible_moves << @starting_positions[n + 7].coordinates if n % 8 != 0 && n < 56
    @starting_positions[n].possible_moves << @starting_positions[n - 7].coordinates if n % 8 != 7 && n > 7
  end

  def add_take_opponent_move(n, right, left)
    @starting_positions[n].possible_moves << @starting_positions[n + right].coordinates if n % 8 != 7
    @starting_positions[n].possible_moves << @starting_positions[n + left].coordinates if n % 8 != 0
  end
end

king = King.new("\u2654".encode('utf-8'))
king.generate_moves
p king.all_possible_moves