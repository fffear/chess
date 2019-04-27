$: << "#{File.expand_path('../../chessboard', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"

require 'chess_pieces'
require 'coordinates'

class MoveKnight
  include ChessPieces
  include Coordinates
  attr_accessor :board, :origin, :destination, :own_pieces

  def initialize(origin, destination, board, own_pieces)
    @origin = origin
    @destination = destination
    @board = board
    @own_pieces = own_pieces
  end

  def compute
    return if board.board[convert_coordinates_to_num(@origin)].piece == " "
    return puts "The coordinates entered are invalid." unless valid_coordinate?(@origin) && valid_coordinate?(@destination)
    @start = convert_coordinates_to_num(@origin)
    @final = convert_coordinates_to_num(@destination)
    return unless board.board[@start].piece.piece == @own_pieces[1]
    return puts "Can't move selected piece there." unless valid_move?
    return move_piece_if_no_blocking_pieces if valid_move? && (up_move? || down_move?)
  end

  private
  def move_piece_if_no_blocking_pieces
    return puts "You can't move opponent's pieces." unless own_piece?
    return puts "Can't move selected piece there." if destination_occupied_by_own_piece?
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
  end

  def own_piece?
    own_pieces.include?(board.board[@start].piece.piece)
  end

  def destination_occupied_by_own_piece?
    @board.board[@final].piece != " " && own_pieces.include?(board.board[@final].piece.piece)
  end

  def valid_move?
    board.board[@start].piece.starting_positions[@start].possible_moves.include?(@final)
  end

  def up_move?
    @final > @start && [6, 10, 15, 17].include?(@final - @start)
    #(@final > @start && @final - @start >= 8) || (@final < @start && @start - @final >= 8)
  end

  def down_move?
    @final < @start && [-6, -10, -15, -17].include?(@final - @start)
  #  (@final > @start && @final - @start <= 7) || (@final < @start && @start - @final <= 7)
  end
end