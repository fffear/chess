# # White King
# p "\u2654".encode('utf-8')

# # Black King
# p "\u265A".encode('utf-8')

$: << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'chessboard'

class King
  attr_reader :piece, :starting_positions, :original_position
  attr_accessor :move_count, :time_first_move

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.board
    @move_count = 0
    @time_first_move = 0
    generate_moves
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
    @starting_positions[n].possible_moves << n + 1 if n % 8 != 7
    @starting_positions[n].possible_moves << n - 1 if n % 8 != 0
  end

  def generate_vertical_moves(n)
    @starting_positions[n].possible_moves << n + 8 if n < 56
    @starting_positions[n].possible_moves << n - 8 if n > 7
  end

  def generate_up_right_moves(n)
    @starting_positions[n].possible_moves << n + 9 if n % 8 != 7 && n < 56
    @starting_positions[n].possible_moves << n - 9 if n % 8 != 0 && n > 7
  end

  def generate_up_left_moves(n)
    @starting_positions[n].possible_moves << n + 7 if n % 8 != 0 && n < 56
    @starting_positions[n].possible_moves << n - 7 if n % 8 != 7 && n > 7
  end

  def add_take_opponent_move(n, right, left)
    @starting_positions[n].possible_moves << n + right if n % 8 != 7
    @starting_positions[n].possible_moves << n + left if n % 8 != 0
  end
end

king = King.new("\u2654".encode('utf-8'))
p king.all_possible_moves[0].possible_moves