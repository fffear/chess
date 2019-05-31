$: << "#{File.expand_path('../../modules', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../check_checkmate', __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'
require 'check'

class Stalemate
  include Coordinates
  include PossibleMoves
  include ChessPieces
  attr_accessor :board, :color_of_own_piece, :turn_count, :board_at_check, :king_position, :color_of_opponent_piece

  def initialize(board, color_of_own_piece, turn_count)
    @board = board
    @color_of_own_piece = color_of_own_piece
    @board_at_check = Marshal::dump(@board)
    @turn_count = turn_count
    determine_opponent_piece
    @king_position = find_king_position
  end

  def compute
    !currently_in_check? && player_in_check_if_any_piece_is_moved?
  end

  def player_in_check_if_any_piece_is_moved?
    @board.board.each_with_index do |tile, idx|
      next if tile.piece == " " || color_of_opponent_piece.include?(tile.piece.piece)
      return true if tile.piece.starting_positions[idx].possible_moves.all? do |n|
        #if rook_can_move_legally?(tile, idx, n)
        #  player_in_check_after_moving_piece?(idx, n)
        #elsif king_can_move_legally?(tile, idx, n)
        #  player_in_check_after_moving_piece?(idx, n)
        #end
        player_in_check_after_moving_piece?(idx, n) if piece_can_move_legally?(tile, idx, n)
      end
    end
    false
  end

  private
  def determine_opponent_piece
    @color_of_opponent_piece = WHITE_PIECES if @color_of_own_piece == BLACK_PIECES
    @color_of_opponent_piece = BLACK_PIECES if @color_of_own_piece == WHITE_PIECES
  end

  def find_king_position
    Check.new(board, color_of_own_piece).find_king_position(@color_of_own_piece)
  end

  def currently_in_check?
    Check.new(board, color_of_own_piece).compute
  end

  def player_in_check_after_moving_piece?(idx, n)
    @board_after_attempt_to_move_out_of_check = Marshal::load(@board_at_check)
    @board_after_attempt_to_move_out_of_check.board[n].piece = board.board[idx].piece
    @board_after_attempt_to_move_out_of_check.board[idx].piece = " "
    Check.new(@board_after_attempt_to_move_out_of_check, color_of_own_piece).compute
  end

  def player_in_check_after_moving_with_rook?(tile, idx, n)
    rook_can_move_legally?(tile, idx, n) &&
    player_in_check_after_moving_piece?(idx, n)
  end

  def player_in_check_after_moving_with_king?(tile, idx, n)
    king_can_move_legally?(tile, idx, n) && 
    player_in_check_after_moving_piece?(idx, n)
  end

  def king_can_move_legally?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[4] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    (board.board[n].piece == " " || color_of_own_piece.include?(board.board[n].piece.piece))
  end

  def rook_can_move_legally?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[0] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    rook_path_not_blocked?(idx, n)
  end

  def knight_can_move?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[1] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    (board.board[n].piece == " " || color_of_own_piece.include?(board.board[n].piece.piece))
  end

  def bishop_can_move_legally?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[2] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    bishop_path_not_blocked?(idx, n) &&
    (board.board[n].piece == " " || color_of_own_piece.include?(board.board[n].piece.piece))
  end
  
  def queen_can_move_legally?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[3] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    queen_path_not_blocked?(idx, n) &&
    (board.board[n].piece == " " || color_of_own_piece.include?(board.board[n].piece.piece))
  end

  def pawn_can_move_legally?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[5] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    pawn_diagonal_move?(idx, n)
  end

  def rook_path_not_blocked?(idx, n)
    vertical_move_not_blocked?(idx, n) || horizontal_move_not_blocked?(idx, n)
  end

  def bishop_path_not_blocked?(idx, bp)
    diagonal_bot_left_to_top_right_path_not_blocked?(idx, bp) ||
    diagonal_bot_right_to_top_left_path_not_blocked?(idx, bp)
  end

  def queen_path_not_blocked?(idx, bp)
    vertical_move_not_blocked?(idx, bp) ||
    horizontal_move_not_blocked?(idx, bp) ||
    diagonal_bot_left_to_top_right_path_not_blocked?(idx, bp) ||
    diagonal_bot_right_to_top_left_path_not_blocked?(idx, bp)
  end

  def vertical_move_not_blocked?(idx, n)
    vertical_move?(idx, n) && !(path_blocked?(8, idx, n))
  end

  def horizontal_move_not_blocked?(idx, n)
    horizontal_move?(idx, n) && !(path_blocked?(1, idx, n))
  end

  def diagonal_bot_left_to_top_right_path_not_blocked?(idx, bp)
    diagonal_bot_left_to_top_right_move?(idx, bp) && !path_blocked?(9, idx, bp)
  end

  def diagonal_bot_right_to_top_left_path_not_blocked?(idx, bp)
    diagonal_bot_right_to_top_left_move?(idx, bp) && !path_blocked?(7, idx, bp)
  end

  def piece_can_move_legally?(tile, idx, n)
    rook_can_move_legally?(tile, idx, n) || knight_can_move?(tile, idx, n) ||
    bishop_can_move_legally?(tile, idx, n) || queen_can_move_legally?(tile, idx, n) ||
    pawn_can_move_legally?(tile, idx, n) || king_can_move_legally?(tile, idx, n)
  end
end