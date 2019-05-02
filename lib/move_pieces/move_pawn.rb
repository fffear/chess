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

class MovePawn
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
    return unless board.board[@start].piece.piece == @own_pieces[5]
    return puts "Can't move selected piece there." unless valid_move?
    return move_piece_vertically_if_no_blocking_pieces if valid_move? && vertical_move?
    return move_piece_diagonally_if_no_blocking_pieces if valid_move? && diagonal_move?
  end

  private
  def move_piece_vertically_if_no_blocking_pieces
    if path_blocked_vertically?(8) || destination_occupied_by_own_piece? || destination_occupied_by_opponent_piece?
      return puts "Can't move selected piece there."
    end
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
  end

  def move_piece_diagonally_if_no_blocking_pieces
    if destination_occupied_by_opponent_piece?
      @board.board[@final].piece = board.board[@start].piece
      @board.board[@start].piece = " "
    else
      return puts "Can't move selected piece there."
    end
  end

  def path_blocked_vertically?(shift_factor)
    blocked_upwards?(shift_factor) || blocked_downwards?(shift_factor)
  end

  def blocked_upwards?(shift_factor)
    @start < @final && (@start + shift_factor..@final - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def blocked_downwards?(shift_factor)
    @final < @start && (@final + shift_factor..@start - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def own_piece?
    own_pieces.include?(board.board[@start].piece.piece)
  end

  def destination_occupied_by_own_piece?
    @board.board[@final].piece != " " && own_pieces.include?(board.board[@final].piece.piece)
  end

  def destination_occupied_by_opponent_piece?
    @board.board[@final].piece != " " && !own_pieces.include?(board.board[@final].piece.piece)
  end

  def valid_move?
    board.board[@start].piece.starting_positions[@start].possible_moves.include?(@final)
  end

  def vertical_move?
    [8, 16, -8, -16].one? { |n| @final == @start + n }
  end

  def diagonal_move?
    [7, 9, -7, -9].one? { |n| @final == @start + n }
  end

  def piece_moved?
    (board.board[@start].piece.move_count) != 0
  end
end