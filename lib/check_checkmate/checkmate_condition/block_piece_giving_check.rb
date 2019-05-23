$: << "#{File.expand_path('../../../modules', __FILE__)}"
$: << "#{File.expand_path('../../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../move_pieces', __FILE__)}"
$: << "#{File.expand_path("../../../check_checkmate", __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'
require 'check'

class BlockPieceGivingCheck
  include Coordinates
  include PossibleMoves
  include ChessPieces

  attr_accessor :board, :board_at_check, :board_after_attempt_to_move_out_of_check, :tile_num_of_threatening_piece,
                :color_of_opponent_piece, :color_of_own_piece, :king_position

  def initialize(board, tile_num_of_threatening_piece, king_position, color_of_opponent_piece, color_of_own_piece)
    @board = board
    @board_at_check = Marshal::dump(@board)
    @color_of_opponent_piece = color_of_opponent_piece
    @king_position = king_position
    @color_of_own_piece = color_of_own_piece
    @tile_num_of_threatening_piece = tile_num_of_threatening_piece
  end

  def find_path_of_threatening_piece(n, king_position)
    return @path_of_piece_giving_check = [] if @board.board[n].piece.piece == color_of_opponent_piece[1]
    find_vertical_path_of_piece_giving_check(n, king_position) if vertical_move?(n, king_position)
    find_horizontal_path_of_piece_giving_check(n, king_position) if horizontal_move?(n, king_position)
    find_diagonal_bot_right_to_top_left_path_of_piece_giving_check(n, king_position) if diagonal_bot_right_to_top_left_move?(n, king_position)
    find_diagonal_bot_left_to_top_right_path_of_piece_giving_check(n, king_position) if diagonal_bot_left_to_top_right_move?(n, king_position)
  end

  def player_still_in_check_when_path_of_piece_giving_check_is_blocked?(tile, idx, bp)
    player_not_in_check_after_blocking_piece_giving_check_with_rook?(tile, idx, bp) ||
    player_not_in_check_after_blocking_piece_giving_check_with_knight?(tile, idx, bp) || 
    player_not_in_check_after_blocking_piece_giving_check_with_bishop?(tile, idx, bp) ||
    player_not_in_check_after_blocking_piece_giving_check_with_queen?(tile, idx, bp) ||
    player_not_in_check_after_blocking_piece_giving_check_with_pawn?(tile, idx, bp)
  end

  def compute
    #p "This is test 4"
    @relevant_pieces = @color_of_opponent_piece.select(&select_rook_bishop_queen)
    return true unless threatening_pieces_are_rook_bishop_queen?
    @tile_num_of_threatening_piece.each do |n|
      next if !piece_is_rook_bishop_queen?(n) || threatening_piece_adjacent_to_king?(n, @king_position)
      find_path_of_threatening_piece(n, @king_position)
      @board.board.each_with_index do |tile, idx|
        next if tile_not_own_piece?(tile) || unable_to_block_path?(tile, idx)
        return false if !player_in_check_after_blocking_piece?(tile, idx)
      end
    end
    true
  end

  private
  def select_rook_bishop_queen
    lambda { |p| [0, 2, 3].each { |n| p == @color_of_opponent_piece[n] } }
  end

  def threatening_pieces_are_rook_bishop_queen?
    @tile_num_of_threatening_piece.any? { |tp| @relevant_pieces.include?(@board.board[tp].piece.piece) }
  end

  def piece_is_rook_bishop_queen?(tile_num)
    @relevant_pieces.include?(@board.board[tile_num].piece.piece)
  end

  def find_vertical_path_of_piece_giving_check(n, king_position)
    if n < king_position
      @path_of_piece_giving_check = n.step(king_position, 8).reject { |num| num == n || num == king_position }
    elsif n > king_position
      @path_of_piece_giving_check = king_position.step(n, 8).reject { |num| num == n || num == king_position }
    end
  end

  def find_horizontal_path_of_piece_giving_check(n, king_position)
    if n < king_position
      @path_of_piece_giving_check = n.step(king_position, 1).reject { |num| num == n || num == king_position }
    elsif n > king_position
      @path_of_piece_giving_check = king_position.step(n, 1).reject { |num| num == n || num == king_position }
    end
  end

  def find_diagonal_bot_left_to_top_right_path_of_piece_giving_check(n, king_position)
    if n < king_position
      @path_of_piece_giving_check = n.step(king_position, 9).reject { |num| num == n || num == king_position }
    elsif n > king_position
      @path_of_piece_giving_check = king_position.step(n, 9).reject { |num| num == n || num == king_position }
    end
  end

  def find_diagonal_bot_right_to_top_left_path_of_piece_giving_check(n, king_position)
    if n < king_position
      @path_of_piece_giving_check = n.step(king_position, 7).reject { |num| num == n || num == king_position }
    elsif n > king_position
      @path_of_piece_giving_check = king_position.step(n, 7).reject { |num| num == n || num == king_position }
    end
  end

  def threatening_piece_adjacent_to_king?(threatening_piece, king_position)
    (king_position == threatening_piece + 8 || king_position == threatening_piece - 8) ||
    (king_position == threatening_piece + 1 || king_position == threatening_piece - 1) ||
    (king_position == threatening_piece + 7 || king_position == threatening_piece - 7) ||
    (king_position == threatening_piece + 9 || king_position == threatening_piece - 9)
  end

  def vertical_path_not_blocked?(idx, bp)
    vertical_move?(idx, bp) && !path_blocked?(8, idx, bp)
  end

  def horizontal_path_not_blocked?(idx, bp)
    horizontal_move?(idx, bp) && !path_blocked?(1, idx, bp)
  end

  def diagonal_bot_left_to_top_right_path_not_blocked?(idx, bp)
    diagonal_bot_left_to_top_right_move?(idx, bp) && !path_blocked?(9, idx, bp)
  end

  def diagonal_bot_right_to_top_left_path_not_blocked?(idx, bp)
    diagonal_bot_right_to_top_left_move?(idx, bp) && !path_blocked?(7, idx, bp)
  end

  def possible_positions_to_block_path(tile, idx)
    @path_of_piece_giving_check & tile.piece.starting_positions[idx].possible_moves
  end

  def player_in_check_after_blocking_piece_giving_check?(idx, n)
    @board_after_attempt_to_move_out_of_check = Marshal::load(@board_at_check)
    @board_after_attempt_to_move_out_of_check.board[n].piece = @board.board[idx].piece
    @board_after_attempt_to_move_out_of_check.board[idx].piece = " "
    Check.new(@board_after_attempt_to_move_out_of_check, color_of_own_piece).compute
  end

  def rook_can_block_path_of_piece_giving_check?(tile, idx, bp)
    tile.piece.piece == color_of_own_piece[0] &&
    tile.piece.starting_positions[idx].possible_moves.include?(bp) &&
    rook_path_not_blocked?(idx, bp)
  end

  def knight_can_block_path_of_piece_giving_check?(tile, idx, bp)
    tile.piece.piece == color_of_own_piece[1] &&
    tile.piece.starting_positions[idx].possible_moves.include?(bp)
  end

  def bishop_can_block_path_of_piece_giving_check?(tile, idx, bp)
    tile.piece.piece == color_of_own_piece[2] &&
    tile.piece.starting_positions[idx].possible_moves.include?(bp)
  end

  def queen_can_block_path_of_piece_giving_check?(tile, idx, bp)
    tile.piece.piece == color_of_own_piece[3] &&
    tile.piece.starting_positions[idx].possible_moves.include?(bp)
  end

  def pawn_can_block_path_of_piece_giving_check?(tile, idx, bp)
    tile.piece.piece == color_of_own_piece[5] &&
    tile.piece.starting_positions[idx].possible_moves.include?(bp)
  end

  def rook_path_not_blocked?(idx, bp)
    vertical_path_not_blocked?(idx, bp) || horizontal_path_not_blocked?(idx, bp)
  end

  def bishop_path_not_blocked?(idx, bp)
    diagonal_bot_left_to_top_right_path_not_blocked?(idx, bp) ||
    diagonal_bot_right_to_top_left_path_not_blocked?(idx, bp)
  end

  def queen_path_not_blocked?(idx, bp)
    vertical_path_not_blocked?(idx, bp) ||
    horizontal_path_not_blocked?(idx, bp) ||
    diagonal_bot_left_to_top_right_path_not_blocked?(idx, bp) ||
    diagonal_bot_right_to_top_left_path_not_blocked?(idx, bp)
  end

  def player_not_in_check_after_blocking_piece_giving_check_with_rook?(tile, idx, n)
    rook_can_block_path_of_piece_giving_check?(tile, idx, n) &&
    !player_in_check_after_blocking_piece_giving_check?(idx, n)
  end

  def player_not_in_check_after_blocking_piece_giving_check_with_knight?(tile, idx, n)
    knight_can_block_path_of_piece_giving_check?(tile, idx, n) &&
    !player_in_check_after_blocking_piece_giving_check?(idx, n)
  end

  def player_not_in_check_after_blocking_piece_giving_check_with_bishop?(tile, idx, bp)
    bishop_can_block_path_of_piece_giving_check?(tile, idx, bp) &&
    bishop_path_not_blocked?(idx, bp) &&
    !player_in_check_after_blocking_piece_giving_check?(idx, bp)
  end

  def player_not_in_check_after_blocking_piece_giving_check_with_queen?(tile, idx, bp)
    queen_can_block_path_of_piece_giving_check?(tile, idx, bp) &&
    queen_path_not_blocked?(idx, bp) &&
    !player_in_check_after_blocking_piece_giving_check?(idx, bp)
  end

  def player_not_in_check_after_blocking_piece_giving_check_with_pawn?(tile, idx, bp)
    pawn_can_block_path_of_piece_giving_check?(tile, idx, bp) &&
    horizontal_path_not_blocked?(idx, bp) &&
    !player_in_check_after_blocking_piece_giving_check?(idx, bp)
  end

  def tile_not_own_piece?(tile)
    tile.piece == " " ||
    @color_of_opponent_piece.include?(tile.piece.piece)
  end

  def unable_to_block_path?(tile, idx)
    possible_positions_to_block_path(tile, idx).length == 0
  end

  def player_in_check_after_blocking_piece?(tile, idx)
    possible_positions_to_block_path(tile, idx).each do |bp|
      return false if player_still_in_check_when_path_of_piece_giving_check_is_blocked?(tile, idx, bp)
    end
  end
end