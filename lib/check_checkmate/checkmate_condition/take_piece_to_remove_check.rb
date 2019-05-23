$: << "#{File.expand_path('../../../modules', __FILE__)}"
$: << "#{File.expand_path('../../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../move_pieces', __FILE__)}"
$: << "#{File.expand_path("../../../check_checkmate", __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'
require 'check'

class TakePieceToRemoveCheck
  include Coordinates
  include PossibleMoves
  include ChessPieces

  attr_accessor :board, :board_at_check, :board_after_attempt_to_move_out_of_check, :tile_num_of_threatening_piece,
                :color_of_opponent_piece, :color_of_own_piece, :turn_count

  def initialize(board, tile_num_of_threatening_piece, color_of_opponent_piece, color_of_own_piece, turn_count)
    @board = board
    @board_at_check = Marshal::dump(@board)
    @color_of_opponent_piece = color_of_opponent_piece
    @color_of_own_piece = color_of_own_piece
    @tile_num_of_threatening_piece = tile_num_of_threatening_piece
    @turn_count = turn_count
  end

  def compute
    #p "This is inside test 3"
    return false if @tile_num_of_threatening_piece.length == 0
    @board.board.each_with_index do |tile, idx|
      next if tile.piece == " " || color_of_opponent_piece.include?(tile.piece.piece)
      @tile_num_of_threatening_piece.each do |n|
        if player_not_in_check_after_taking_piece_giving_check?(tile, idx, n)
          return false 
        end
      end
    end
    #p "Testing if take piece to remove check returns true"
    return true
  end

  private
  def player_not_in_check_after_taking_piece_giving_check?(tile, idx, n)
    player_not_in_check_after_taking_piece_giving_check_with_rook?(tile, idx, n) ||
    player_not_in_check_after_taking_piece_giving_check_with_bishop?(tile, idx, n) ||
    player_not_in_check_after_taking_piece_giving_check_with_pawn?(tile, idx, n) ||
    player_not_in_check_after_taking_piece_giving_check_with_queen?(tile, idx, n) ||
    player_not_in_check_after_taking_piece_giving_check_with_knight?(tile, idx, n) ||
    player_not_in_check_after_taking_piece_giving_check_with_king?(tile, idx, n)
  end

  def player_in_check_after_taking_piece_giving_check?(idx, n)
    @board_after_attempt_to_move_out_of_check = Marshal::load(@board_at_check)
    @board_after_attempt_to_move_out_of_check.board[n].piece = board.board[idx].piece
    @board_after_attempt_to_move_out_of_check.board[idx].piece = " "
    Check.new(@board_after_attempt_to_move_out_of_check, color_of_own_piece).compute
  end

  def player_in_check_after_taking_piece_giving_check_by_enpassant?(idx, n)
    @board_after_attempt_to_move_out_of_check = Marshal::load(@board_at_check)
    @board_after_attempt_to_move_out_of_check.board[n].piece = " "
    if n > idx
      @board_after_attempt_to_move_out_of_check.board[n + 8].piece = board.board[idx].piece
    elsif n < idx
      @board_after_attempt_to_move_out_of_check.board[n - 8].piece = board.board[idx].piece
    end
    @board_after_attempt_to_move_out_of_check.board[idx].piece = " "
    Check.new(@board_after_attempt_to_move_out_of_check, color_of_own_piece).compute
  end

  def player_not_in_check_after_taking_piece_giving_check_with_rook?(tile, idx, n)
    rook_can_take_opponent_piece_giving_check?(tile, idx, n) &&
    !player_in_check_after_taking_piece_giving_check?(idx, n)
  end

  def player_not_in_check_after_taking_piece_giving_check_with_bishop?(tile, idx, n)
    bishop_can_take_opponent_piece_giving_check?(tile, idx, n) && 
    !player_in_check_after_taking_piece_giving_check?(idx, n)
  end

  def player_not_in_check_after_taking_piece_giving_check_with_pawn?(tile, idx, n)
    (pawn_can_take_opponent_piece_giving_check?(tile, idx, n) &&
    !player_in_check_after_taking_piece_giving_check?(idx, n)) ||
    (tile.piece.piece == color_of_own_piece[5] && enpassant_conditions?(idx, n) &&
    !player_in_check_after_taking_piece_giving_check_by_enpassant?(idx, n))
  end

  def player_not_in_check_after_taking_piece_giving_check_with_queen?(tile, idx, n)
    queen_can_take_opponent_piece_giving_check?(tile, idx, n) &&
    !player_in_check_after_taking_piece_giving_check?(idx, n)
  end

  def player_not_in_check_after_taking_piece_giving_check_with_knight?(tile, idx, n)
    knight_can_take_opponent_piece_giving_check?(tile, idx, n) &&
    !player_in_check_after_taking_piece_giving_check?(idx, n)
  end

  def player_not_in_check_after_taking_piece_giving_check_with_king?(tile, idx, n)
    king_can_take_opponent_piece_giving_check?(tile, idx, n) && 
    !player_in_check_after_taking_piece_giving_check?(idx, n)
  end

  def rook_can_take_opponent_piece_giving_check?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[0] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    rook_path_not_blocked?(idx, n)
  end

  def bishop_can_take_opponent_piece_giving_check?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[2] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    bishop_path_not_blocked(idx, n)
  end

  def pawn_can_take_opponent_piece_giving_check?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[5] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    pawn_diagonal_move?(idx, n)
  end

  def enpassant_conditions?(idx, n)
    #p "Testing Enpassant conditions"
    #p @turn_count
    #p board.board[n].piece.time_first_move
    enpassant_up?(idx, n) || enpassant_down?(idx, n)
  end

  def enpassant_up?(idx, n)
    n > idx && @board.board[n].piece.piece == color_of_opponent_piece[5] &&
    next_move?(idx, n) && @board.board[n + 8].piece == " " &&
    (@board.board[n].piece.piece == BLACK_PIECES[5] && n >= 32 && n <= 39)
  end

  def enpassant_down?(idx, n)
    idx > n && @board.board[n].piece.piece == color_of_opponent_piece[5] &&
    next_move?(idx, n) && @board.board[n - 8].piece == " " &&
    (@board.board[n].piece.piece == WHITE_PIECES[5] && n >= 24 && n <= 31)
  end

  def next_move?(idx, n)
    if n > idx
      @turn_count == board.board[n].piece.time_first_move + 1
    elsif idx > n
      @turn_count == board.board[n].piece.time_first_move + 1
    end
  end

  def queen_can_take_opponent_piece_giving_check?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[3] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n) &&
    queen_path_not_blocked?(idx, n)
  end

  def knight_can_take_opponent_piece_giving_check?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[1] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n)
  end

  def king_can_take_opponent_piece_giving_check?(tile, idx, n)
    tile.piece.piece == color_of_own_piece[4] &&
    tile.piece.starting_positions[idx].possible_moves.include?(n)
  end

  def vertical_move_not_blocked?(idx, n)
    vertical_move?(idx, n) && !(path_blocked?(8, idx, n))
  end

  def horizontal_move_not_blocked?(idx, n)
    horizontal_move?(idx, n) && !(path_blocked?(1, idx, n))
  end

  def diagonal_bot_left_to_top_right_not_blocked?(idx, n)
    diagonal_bot_left_to_top_right_move?(idx, n) && !(path_blocked?(9, idx, n))
  end

  def diagonal_bot_right_to_top_left_not_blocked?(idx, n)
    diagonal_bot_right_to_top_left_move?(idx, n) && !(path_blocked?(7, idx, n))
  end

  def rook_path_not_blocked?(idx, n)
    vertical_move_not_blocked?(idx, n) || horizontal_move_not_blocked?(idx, n)
  end

  def bishop_path_not_blocked(idx, n)
    diagonal_bot_left_to_top_right_not_blocked?(idx, n) || diagonal_bot_right_to_top_left_not_blocked?(idx, n)
  end

  def queen_path_not_blocked?(idx, n)
    vertical_move_not_blocked?(idx, n) || horizontal_move_not_blocked?(idx, n) ||
    diagonal_bot_left_to_top_right_not_blocked?(idx, n) || diagonal_bot_right_to_top_left_not_blocked?(idx, n)
  end
end