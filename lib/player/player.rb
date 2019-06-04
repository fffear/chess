$: << "#{File.expand_path("../../chess_pieces", __FILE__)}"
$: << "#{File.expand_path("../../move_pieces", __FILE__)}"

require 'chess_pieces'
require 'coordinates'

class Player
  include ChessPieces
  include Coordinates

  attr_reader :color, :pieces, :opponent_pieces

  def initialize(color, pieces, opponent_pieces)
    @color = color
    @pieces = pieces
    @opponent_pieces = opponent_pieces
  end

  
  def move_piece(origin, destination, board, pieces, opponent_pieces, turn_count)
    return puts "There is no chess piece on this tile." if board.board[convert_coordinates_to_num(origin)].piece == " "
    MoveRook.new(origin, destination, board, pieces, turn_count).compute #if board.board[convert_coordinates_to_num(origin)].piece == rook?
    MoveKnight.new(origin, destination, board, pieces).compute #if board.board[convert_coordinates_to_num(origin)].piece == knight?
    MoveBishop.new(origin, destination, board, pieces).compute
    MoveQueen.new(origin, destination, board, pieces).compute
    MoveKing.new(origin, destination, board, pieces, turn_count).compute
    MovePawn.new(origin, destination, board, pieces, opponent_pieces, turn_count).compute
  end

  private
  def rook?
    ChessPieces::WHITE_PIECES[0] || ChessPieces::BLACK_PIECES[0]
  end

  def knight?
    ChessPieces::WHITE_PIECES[1] || ChessPieces::BLACK_PIECES[1]
  end
end