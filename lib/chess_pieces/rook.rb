#White Rook
#p "\u2656".encode('utf-8')

#Black Rook
#p "\u265C".encode('utf-8')

$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'generate_moves'

class Rook
  attr_reader :piece, :starting_positions
  attr_accessor :time_first_move

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.board
    @time_first_move = 0
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

#rook = Rook.new("\u2656".encode('utf-8'))
#p rook
