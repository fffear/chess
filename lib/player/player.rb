$: << "#{File.expand_path("../../chess_pieces", __FILE__)}"
require 'chess_pieces'

class Player
  include ChessPieces

  attr_reader :color, :pieces

  def initialize(color, pieces)
    @color = color
    @pieces = pieces
  end

  def move_piece(origin, destination, board, pieces)
    MoveRook.new(origin, destination, board, pieces).compute
    MoveKnight.new(origin, destination, board, pieces).compute
  end
end


# player = Player.new("white", ChessPieces::WHITE_PIECES)
# p player.pieces
