$: << "#{File.expand_path('../../modules', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'

class Check
  attr_accessor :board, :color_of_own_piece, :color_of_opponent_piece, :king_position

  include Coordinates
  include PossibleMoves
  include ChessPieces
  #include GenerateMoves

  def initialize(board, color_of_own_piece)
    @board = board
    @color_of_own_piece = color_of_own_piece
    determine_opponent_piece
    #@color_of_opponent_piece = color_of_opponent_piece
    #@own_piece = @color_of_opponent_piece
  end

  def determine_opponent_piece
    @color_of_opponent_piece = WHITE_PIECES if @color_of_own_piece == BLACK_PIECES
    @color_of_opponent_piece = BLACK_PIECES if @color_of_own_piece == WHITE_PIECES
  end

  def compute
    find_king_position(@color_of_own_piece)
    king_in_check?(@king_position)
  end

  def castling_check?(shift_factor)
    find_king_position(@color_of_own_piece)
    board.board.each_with_index do |tile, idx|
      next if tile.piece == " " || tile.piece == King
      return true if opponent_rook_threatening_king?(tile, idx, shift_factor)
      return true if opponent_knight_threatening_king?(tile, idx, shift_factor)
      return true if opponent_bishop_threatening_king?(tile, idx, shift_factor)
      return true if opponent_queen_threatening_king?(tile, idx, shift_factor)
      return true if opponent_pawn_threatening_king?(tile, idx, shift_factor)
    end
    false
  end

  def find_king_position(color)
    board.board.each_with_index do |tile, idx|
      next if tile.piece == " "
      if color == WHITE_PIECES
      #if color == "white"
        return @king_position = idx if tile.piece.piece == WHITE_PIECES[4]
      else
        return @king_position = idx if tile.piece.piece == BLACK_PIECES[4]
      end
    end
  end

  def opponent_rook_threatening_king?(tile, idx, shift_factor)
    if tile.piece.piece == color_of_opponent_piece[0] && tile.piece.starting_positions[idx].possible_moves.include?(@king_position + shift_factor)
      return true if vertical_move?(idx, @king_position + shift_factor) && !(path_blocked?(8, idx, @king_position + shift_factor))
      return true if horizontal_move?(idx, @king_position + shift_factor) && !(path_blocked?(1, idx, @king_position + shift_factor))
    end
    false
  end

  def opponent_knight_threatening_king?(tile, idx, shift_factor)
    if tile.piece.piece == color_of_opponent_piece[1] && tile.piece.starting_positions[idx].possible_moves.include?(@king_position + shift_factor)
      return true
    end
    false
  end

  def opponent_bishop_threatening_king?(tile, idx, shift_factor)
    if tile.piece.piece == color_of_opponent_piece[2] && tile.piece.starting_positions[idx].possible_moves.include?(king_position + shift_factor)
      return true if diagonal_bot_left_to_top_right_move?(idx, king_position + shift_factor) && !path_blocked?(9, idx, king_position + shift_factor)
      return true if diagonal_bot_right_to_top_left_move?(idx, king_position + shift_factor) && !path_blocked?(7, idx, king_position + shift_factor)        
    end
    false
  end

  def opponent_queen_threatening_king?(tile, idx, shift_factor)
    if tile.piece.piece == color_of_opponent_piece[3] && tile.piece.starting_positions[idx].possible_moves.include?(king_position + shift_factor)
      return true if vertical_move?(idx, king_position + shift_factor) && !path_blocked?(8, idx, king_position + shift_factor)
      return true if horizontal_move?(idx, king_position + shift_factor) && !path_blocked?(1, idx, king_position + shift_factor)
      return true if diagonal_bot_left_to_top_right_move?(idx, king_position + shift_factor) && !path_blocked?(9, idx, king_position + shift_factor)
      return true if diagonal_bot_right_to_top_left_move?(idx, king_position + shift_factor) && !path_blocked?(7, idx, king_position + shift_factor)
    end
    false
  end

  def opponent_pawn_threatening_king?(tile, idx, shift_factor)
    if tile.piece.piece == color_of_opponent_piece[5] && tile.piece.starting_positions[idx].possible_moves.include?(king_position + shift_factor)
      return true if pawn_diagonal_move?(idx, king_position + shift_factor)
    end
    false
  end

  def king_in_check?(king_position)
    board.board.each_with_index do |tile, idx|
      next if tile.piece == " " || tile.piece == King
      return true if opponent_rook_threatening_king?(tile, idx, 0)
      return true if opponent_knight_threatening_king?(tile, idx, 0)
      return true if opponent_bishop_threatening_king?(tile, idx, 0)
      return true if opponent_queen_threatening_king?(tile, idx, 0)
      return true if opponent_pawn_threatening_king?(tile, idx, 0)
    end
    false
  end
end
