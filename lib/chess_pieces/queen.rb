$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'generate_moves'

class Queen
  attr_reader :piece, :starting_positions

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.board
    generate_all_moves(starting_positions)
  end

  def generate_all_moves(starting_positions)
    generate_all_vertical_moves(starting_positions)
    generate_all_horizontal_moves(starting_positions)
    generate_all_diagonal_moves
  end

  def all_possible_moves
    @starting_positions
  end
end