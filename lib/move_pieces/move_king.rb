$: << "#{File.expand_path('../../chessboard', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../check_checkmate', __FILE__)}"

require 'chess_pieces'
require 'coordinates'
require 'check'

#require 'chessboard'
#require 'rook'
#require 'knight'
#require 'bishop'
#require 'queen'
#require 'king'
#require 'pawn'

class MoveKing
  include ChessPieces
  include Coordinates
  attr_accessor :board, :origin, :destination, :own_pieces, :opponent_pieces, :turn_count

  def initialize(origin, destination, board, own_pieces, turn_count)
    @origin = origin
    @destination = destination
    @board = board
    @own_pieces = own_pieces
    @turn_count = turn_count
    determine_opponent_pieces
  end

  def compute
    return if board.board[convert_coordinates_to_num(@origin)].piece == " "
    return puts "The coordinates entered are invalid." unless valid_coordinate?(@origin) && valid_coordinate?(@destination)
    @start = convert_coordinates_to_num(@origin)
    @final = convert_coordinates_to_num(@destination)
    return unless board.board[@start].piece.piece == @own_pieces[4]
    return castle_king if castling_conditions_met?
    return puts "Can't move selected piece there." unless valid_move?
    return move_piece_if_no_blocking_pieces(8) if valid_move? && vertical_move?
    return move_piece_if_no_blocking_pieces(1) if valid_move? && horizontal_move?
    return move_piece_if_no_blocking_pieces(9) if valid_move? && diagonal_bot_left_to_top_right_move?
    return move_piece_if_no_blocking_pieces(7) if valid_move? && diagonal_bot_right_to_top_left__move?
  end

  private
  def determine_opponent_pieces
    @opponent_pieces = BLACK_PIECES if @own_pieces == WHITE_PIECES
    @opponent_pieces = WHITE_PIECES if @own_pieces == BLACK_PIECES
  end

  def move_piece_if_no_blocking_pieces(shift_factor)
    return puts "You can't move opponent's pieces." unless own_piece?
    return puts "Can't move selected piece there." if path_blocked?(shift_factor) || destination_occupied_by_own_piece?
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
    @board.board[@final].piece.time_first_move = @turn_count if (@board.board[@final].piece.time_first_move).zero?
  end

  def castling_conditions_met?
    (@start - @final == 2 && board.board[@final - 2].piece != " " && (@final - 1..@start - 1).all? { |n| board.board[n].piece == " " } && rook_unmoved?(-2) && king_unmoved?) ||
    (@final - @start == 2 && board.board[@final + 1].piece != " " && (@start + 1..@final).all? { |n| board.board[n].piece == " " } && rook_unmoved?(1) && king_unmoved?)
  end

  #def king_in_check?(board, color_of_own_piece, opponent_pieces)
  #  Check.new(board, color_of_own_piece, opponent_pieces).compute
  #end

  def king_in_check?(board, color_of_own_piece)
    Check.new(board, color_of_own_piece).compute
  end

  #def tile_adjacent_to_king_threatened?(board, color_of_own_piece, opponent_pieces, shift_factor)
  #  Check.new(board, color_of_own_piece, opponent_pieces).castling_check?(shift_factor)
  #end

  def tile_adjacent_to_king_threatened?(board, color_of_own_piece, shift_factor)
    Check.new(board, color_of_own_piece).castling_check?(shift_factor)
  end

  def castle_queenside
    return puts "Can't castle through check." if tile_adjacent_to_king_threatened?(board, @own_pieces, -1) || tile_adjacent_to_king_threatened?(board, @own_pieces, -2)# || tile_adjacent_to_king_threatened?(board, BLACK_PIECES, -1)
    return puts "There is no rook present to castle" if board.board[@final - 2].piece == " "
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
    @board.board[@final + 1].piece = board.board[@final - 2].piece
    @board.board[@final - 2].piece = " "
    @board.board[@final].piece.time_first_move = @turn_count
    @board.board[@final + 1].piece.time_first_move = @turn_count
    p @board.board[@final].piece.time_first_move
    p @board.board[@final + 1].piece.time_first_move
  end

  def castle_kingside
    return puts "Can't castle through check." if tile_adjacent_to_king_threatened?(board, @own_pieces, 1) || tile_adjacent_to_king_threatened?(board, @own_pieces, 2)# || tile_adjacent_to_king_threatened?(board, BLACK_PIECES, 1)
    return puts "There is no rook present to castle" if board.board[@final + 1].piece == " "
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
    @board.board[@final - 1].piece = board.board[@final + 1].piece
    @board.board[@final + 1].piece = " "
    @board.board[@final].piece.time_first_move = @turn_count
    @board.board[@final - 1].piece.time_first_move = @turn_count
    p @board.board[@final].piece.time_first_move
    p @board.board[@final - 1].piece.time_first_move
  end

  def castle_king
    return puts "Can't castle, king is in check." if king_in_check?(board, @own_pieces) #|| king_in_check?(board, BLACK_PIECES, WHITE_PIECES)
    @final < @start ? castle_queenside : castle_kingside
  end

  def rook_unmoved?(n)
    return false if board.board[@final + n].piece == " "
    board.board[@final + n].piece.piece == own_pieces[0] && board.board[@final + n].piece.time_first_move == 0
  end

  def king_unmoved?
    board.board[@start].piece.piece == own_pieces[4] && board.board[@start].piece.time_first_move == 0
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
    [8, -8].one? { |n| @final == @start + n }
  end

  def horizontal_move?
    [1, -1].one? { |n| @final == @start + n }
  end

  def diagonal_bot_left_to_top_right_move?
    [9, -9].one? { |n| @final == @start + n }
  end

  def diagonal_bot_right_to_top_left__move?
    [7, -7].one? { |n| @final == @start + n }
  end
end