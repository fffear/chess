# White Bishop
# p "\u2657".encode('utf-8')

# # Black Bishop
# p "\u265D".encode('utf-8')

$: << File.expand_path("../../chess_pieces", __FILE__)
require 'generate_moves'

class Bishop
  attr_reader :piece, :starting_positions

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
  end

  #def generate_all_moves(starting_positions)
  #end

  def all_possible_moves
    @starting_positions
  end
end

bishop = Bishop.new("\u2657".encode('utf-8'))
p bishop.generate_all_diagonal_moves
p bishop.starting_positions[27]