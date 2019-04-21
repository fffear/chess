#White Rook
#p "\u2656".encode('utf-8')

#Black Rook
#p "\u265C".encode('utf-8')

$LOAD_PATH << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'generate_moves'

class Rook
  attr_reader :piece, :starting_positions

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
    generate_all_moves(starting_positions)
  end

  def generate_all_moves(starting_positions)
    generate_all_vertical_moves(starting_positions)
    generate_all_horizontal_moves(starting_positions)
  end

  def all_possible_moves
    @starting_positions
  end
end



rook = Rook.new("\u2656".encode('utf-8'))
#p rook.starting_positions
p rook.all_possible_moves

# # White King
# p "\u2654".encode('utf-8')
# 
# # White Queen
# p "\u2655".encode('utf-8')
# 
# #White Rook
# p "\u2656".encode('utf-8')
# 
# # White Bishop
# p "\u2657".encode('utf-8')
# 
# # White Knight
# p "\u2658".encode('utf-8')
# 
# # White Pawn
# p "\u2659".encode('utf-8')
# 
# 
# 
# # Black King
# p "\u265A".encode('utf-8')
# 
# # Black Queen
# p "\u265B".encode('utf-8')
# 
# #Black Rook
# p "\u265C".encode('utf-8')
# 
# # Black Bishop
# p "\u265D".encode('utf-8')
# 
# # Black Knight
# p "\u265E".encode('utf-8')
# 
# # Black Pawn
# p "\u265F".encode('utf-8')