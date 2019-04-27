$: << "#{File.expand_path('../../chessboard', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"

require 'chess_pieces'
require 'coordinates'

#require 'chessboard'
#require 'rook'
#require 'knight'
#require 'bishop'
#require 'queen'
#require 'king'
#require 'pawn'

class MoveRook
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
    return puts "The coordinates entered are invalid." unless valid_coordinate?(@origin) && valid_coordinate?(@destination)
    @start = convert_coordinates_to_num(@origin)
    @final = convert_coordinates_to_num(@destination)
    return unless board.board[@start].piece.piece == @own_pieces[0]
    return puts "Can't move selected piece there." unless valid_move?
    return move_piece_if_no_blocking_pieces(8) if valid_move? && vertical_move?
    return move_piece_if_no_blocking_pieces(1) if valid_move? && horizontal_move?
  end

  private
  def move_piece_if_no_blocking_pieces(shift_factor)
    return puts "You can't move opponent's pieces." unless own_piece?
    return puts "Can't move selected piece there." if path_blocked?(shift_factor) || destination_occupied_by_own_piece?
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
  end

  def path_blocked?(shift_factor)
    blocked_vertically?(shift_factor) || blocked_horizontally?(shift_factor)
  end

  def own_piece?
    own_pieces.include?(board.board[@start].piece.piece)
  end

  def destination_occupied_by_own_piece?
    @board.board[@final].piece != " " && own_pieces.include?(board.board[@final].piece.piece)
  end

  def blocked_vertically?(shift_factor)
    @start < @final && (@start + shift_factor..@final - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def blocked_horizontally?(shift_factor)
    @final < @start && (@final + shift_factor..@start - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def valid_move?
    board.board[@start].piece.starting_positions[@start].possible_moves.include?(@final)
  end

  def vertical_move?
    (@final > @start && @final - @start >= 8) || (@final < @start && @start - @final >= 8)
  end

  def horizontal_move?
    (@final > @start && @final - @start <= 7) || (@final < @start && @start - @final <= 7)
  end
end