$: << "#{File.expand_path('../../modules', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../check_checkmate', __FILE__)}"
$: << "#{File.expand_path('../../check_checkmate/checkmate_condition', __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'
require 'check'
require 'take_piece_to_remove_check'
require 'block_piece_giving_check'

class CheckMate
  attr_accessor :tile_num_of_threatening_piece, :board, :color_of_own_piece, :color_of_opponent_piece, :board_at_check, :king_position, :board_after_attempt_to_move_out_of_check
                :turn_count
  include Coordinates
  include PossibleMoves
  include ChessPieces

  def initialize(board, color_of_own_piece, turn_count)
    @board = board
    @color_of_own_piece = color_of_own_piece
    @board_at_check = Marshal::dump(@board)
    @turn_count = turn_count
    determine_opponent_piece
    @king_position = find_king_position
    find_tile_num_of_threatening_piece
  end

  def compute
    currently_in_check? && impossible_to_move_out_of_check_by_moving_king? &&
    impossible_to_take_piece_that_gives_check_to_remove_check? && remove_check_by_blocking_piece_giving_check?
  end

  def impossible_to_move_out_of_check_by_moving_king?
    fail_to_move_king_out_of_check?
  end

  def impossible_to_take_piece_that_gives_check_to_remove_check?
    TakePieceToRemoveCheck.new(@board, @tile_num_of_threatening_piece, @color_of_opponent_piece, @color_of_own_piece, @turn_count).compute
  end

  def remove_check_by_blocking_piece_giving_check?
    BlockPieceGivingCheck.new(@board, @tile_num_of_threatening_piece, @king_position, @color_of_opponent_piece, @color_of_own_piece).compute
  end
  
  private
  def find_tile_num_of_threatening_piece
    @tile_num_of_threatening_piece = []
    @board.board.each_with_index do |tile, idx|
      next if tile.piece == " "
      find_tile_num_of_rook_threatening_king(idx) if rook_threatens_king?(tile, idx)
      find_tile_num_of_knight_threatening_king(idx) if knight_threatens_king?(tile, idx)
      find_tile_num_of_bishop_threatening_king(idx) if bishop_threatens_king?(tile, idx)
      find_tile_num_of_queen_threatening_king(idx) if queen_threatens_king?(tile, idx)
      find_tile_num_of_pawn_threatening_king(idx) if pawn_threatens_king?(tile, idx)
    end
  end

  def rook_threatens_king?(tile, idx)
    tile.piece.piece == color_of_opponent_piece[0] &&
    tile.piece.starting_positions[idx].possible_moves.include?(@king_position)
  end

  def knight_threatens_king?(tile, idx)
    tile.piece.piece == color_of_opponent_piece[1] &&
    tile.piece.starting_positions[idx].possible_moves.include?(@king_position)
  end

  def bishop_threatens_king?(tile, idx)
    tile.piece.piece == color_of_opponent_piece[2] &&
    tile.piece.starting_positions[idx].possible_moves.include?(@king_position)
  end

  def queen_threatens_king?(tile, idx)
    tile.piece.piece == color_of_opponent_piece[3] &&
    tile.piece.starting_positions[idx].possible_moves.include?(@king_position)
  end

  def pawn_threatens_king?(tile, idx)
    tile.piece.piece == color_of_opponent_piece[5] &&
    tile.piece.starting_positions[idx].possible_moves.include?(@king_position)
  end

  def find_tile_num_of_rook_threatening_king(idx)
    @tile_num_of_threatening_piece << idx if vertical_move?(idx, @king_position) && !(path_blocked?(8, idx, @king_position))
    @tile_num_of_threatening_piece << idx if horizontal_move?(idx, @king_position) && !(path_blocked?(1, idx, @king_position))
  end

  def find_tile_num_of_bishop_threatening_king(idx)
    @tile_num_of_threatening_piece << idx if diagonal_bot_left_to_top_right_move?(idx, @king_position) && !(path_blocked?(9, idx, @king_position))
    @tile_num_of_threatening_piece << idx if diagonal_bot_right_to_top_left_move?(idx, @king_position) && !(path_blocked?(7, idx, @king_position))
  end

  def find_tile_num_of_queen_threatening_king(idx)
    find_tile_num_of_rook_threatening_king(idx)
    find_tile_num_of_bishop_threatening_king(idx)
  end

  def find_tile_num_of_pawn_threatening_king(idx)
    @tile_num_of_threatening_piece << idx if pawn_diagonal_move?(idx, @king_position)
  end

  def find_tile_num_of_knight_threatening_king(idx)
    @tile_num_of_threatening_piece << idx
  end

  def set_board_at_check
    @board_at_check = Marshal::dump(board)
  end

  def currently_in_check?
    Check.new(board, color_of_own_piece).compute
  end

  def determine_opponent_piece
    @color_of_opponent_piece = WHITE_PIECES if @color_of_own_piece == BLACK_PIECES
    @color_of_opponent_piece = BLACK_PIECES if @color_of_own_piece == WHITE_PIECES
  end

  def find_king_position
    Check.new(board, color_of_own_piece).find_king_position(@color_of_own_piece)
  end

  def fail_to_move_king_out_of_check?
    board.board[@king_position].piece.starting_positions[@king_position].possible_moves.all? do |tile|
      if board.board[tile].piece == " " || color_of_opponent_piece.include?(board.board[tile].piece.piece)
        move_king_out_of_check(tile)
        Check.new(@board_after_attempt_to_move_out_of_check, @color_of_own_piece).compute
      elsif color_of_own_piece.include?(board.board[tile].piece.piece)
        true
      end
    end
  end

  def move_king_out_of_check(tile)
    @board_after_attempt_to_move_out_of_check = Marshal::load(@board_at_check)
    @board_after_attempt_to_move_out_of_check.board[tile].piece = board.board[@king_position].piece
    @board_after_attempt_to_move_out_of_check.board[@king_position].piece = " "
  end
end