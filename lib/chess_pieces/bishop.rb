$: << File.expand_path("../../chess_pieces", __FILE__)
require 'generate_moves'

class Bishop
  attr_reader :piece, :starting_positions

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.board
    generate_all_diagonal_moves
  end

  def all_possible_moves
    @starting_positions
  end
end