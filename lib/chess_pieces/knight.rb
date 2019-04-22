# # White Knight
# p "\u2658".encode('utf-8')

# # Black Knight
# p "\u265E".encode('utf-8')

$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'generate_moves'

class Knight
  attr_reader :piece, :starting_positions

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
    generate_all_knight_moves
  end

  def all_possible_moves
    @starting_positions
  end
end

knight = Knight.new("\u2658".encode('utf-8'))
p knight.starting_positions