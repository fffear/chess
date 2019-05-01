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

class MoveQueen
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
    return unless board.board[@start].piece.piece == @own_pieces[3]
    return puts "Can't move selected piece there." unless valid_move?
    return move_piece_if_no_blocking_pieces(8) if valid_move? && vertical_move?
    return move_piece_if_no_blocking_pieces(1) if valid_move? && horizontal_move?
    return move_piece_if_no_blocking_pieces(9) if valid_move? && diagonal_bot_left_to_top_right_move?
    return move_piece_if_no_blocking_pieces(7) if valid_move? && diagonal_bot_right_to_top_left__move?
  end

  private
  def move_piece_if_no_blocking_pieces(shift_factor)
    return puts "You can't move opponent's pieces." unless own_piece?
    return puts "Can't move selected piece there." if path_blocked?(shift_factor) || destination_occupied_by_own_piece?
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
  end

  def path_blocked?(shift_factor)
    blocked_upwards_and_to_the_right?(shift_factor) || blocked_downwards_and_to_the_left?(shift_factor)
  end

  def own_piece?
    own_pieces.include?(board.board[@start].piece.piece)
  end

  def destination_occupied_by_own_piece?
    @board.board[@final].piece != " " && own_pieces.include?(board.board[@final].piece.piece)
  end

  def blocked_upwards_and_to_the_right?(shift_factor)
    @start < @final && (@start + shift_factor..@final - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def blocked_downwards_and_to_the_left?(shift_factor)
    @final < @start && (@final + shift_factor..@start - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def valid_move?
    board.board[@start].piece.starting_positions[@start].possible_moves.include?(@final)
  end

  def vertical_move?
    (@final > @start && [8, 16, 24, 32, 40, 48, 56].one? { |n| @final == @start + n }) ||
    (@start > @final && [-8, -16, -24, -32, -40, -48, -56].one? { |n| @final == @start + n })
  end

  def horizontal_move?
    (@final > @start && (1..7).one? { |n| @final == @start + n }) ||
    (@start > @final && [-1, -2, -3, -4, -5, -6, -7].one? { |n| @final == @start + n })
  end

  def diagonal_bot_left_to_top_right_move?
    (@final > @start && [9, 18, 27, 36, 45, 54, 63].one? { |n| @final == @start + n }) ||
    (@start > @final && [-9, -18, -27, -36, -45, -54, -63].one? { |n| @final == @start + n })
  end

  def diagonal_bot_right_to_top_left__move?
    (@final > @start && [7, 14, 21, 28, 35, 42, 49].one? { |n| @final == @start + n }) ||
    (@start > @final && [-7, -14, -21, -28, -35, -42, -49].one? { |n| @final == @start + n })
  end
end