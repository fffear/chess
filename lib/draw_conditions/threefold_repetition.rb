$: << "#{File.expand_path('../../modules', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../check_checkmate', __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'
require 'check'

class ThreefoldRepetition
  include Coordinates
  include PossibleMoves
  include ChessPieces
  attr_accessor :board, :color_of_own_piece, :turn_count, :board_at_current_turn, :king_position, :color_of_opponent_piece,
                :board_history, :repeated_turns

  def initialize(board, board_history, turn_count)
    @board = board
    @board_at_current_turn = Marshal::dump(@board)
    @turn_count = turn_count
    @board_history = board_history
  end

  def compute
    turns_same_as_current_board
    times_same_board >= 2 &&
    number_castling_conditions_same_for_repeated_board >= 2 &&
    times_enpassant_position_same >= 2
  end

  private
  def times_same_board
    @board_history.count do |b|
      (0..63).all? do |n|
        if (Marshal::load(b).board[n].piece == " " && @board.board[n].piece == " ") 
          true
        elsif (Marshal::load(b).board[n].piece == " " && @board.board[n].piece != " ")
          false
        elsif (Marshal::load(b).board[n].piece != " " && @board.board[n].piece == " ")
          false
        elsif Marshal::load(b).board[n].piece.piece != @board.board[n].piece.piece
          false
        elsif Marshal::load(b).board[n].piece.piece == @board.board[n].piece.piece
          true
        end
      end
    end
  end

  def turns_same_as_current_board
    @repeated_turns = []
    @board_history.each_with_index do |b, idx|
      @repeated_turns << idx if (0..63).all? do |n|
        if (Marshal::load(b).board[n].piece == " " && @board.board[n].piece == " ") 
          true
        elsif (Marshal::load(b).board[n].piece == " " && @board.board[n].piece != " ")
          false
        elsif (Marshal::load(b).board[n].piece != " " && @board.board[n].piece == " ")
          false
        elsif Marshal::load(b).board[n].piece.piece != @board.board[n].piece.piece
          false
        elsif Marshal::load(b).board[n].piece.piece == @board.board[n].piece.piece
          true
        end
      end
    end
    @repeated_turns
  end

  def times_enpassant_position_same
    @repeated_turns.count do |rt|
      enpassant_possible(Marshal::load(@board_history[rt]), WHITE_PIECES, rt - 1) == enpassant_possible(@board, WHITE_PIECES, @turn_count - 1)
    end
  end

  def number_castling_conditions_same_for_repeated_board
    @repeated_turns.count do |n|
      castling_conditions_same?(@board, Marshal::load(@board_history[n]))
    end
  end

  def castling_conditions_same?(current_board, previous_board)
    (queenside_castling_possible?(current_board, 0, 4, WHITE_PIECES) == queenside_castling_possible?(previous_board, 0, 4, WHITE_PIECES)) &&
    (queenside_castling_possible?(current_board, 56, 60, BLACK_PIECES) == queenside_castling_possible?(previous_board, 56, 60, BLACK_PIECES)) &&
    (kingside_castling_possible?(current_board, 7, 4, WHITE_PIECES) == kingside_castling_possible?(previous_board, 7, 4, WHITE_PIECES)) &&
    (kingside_castling_possible?(current_board, 63, 60, BLACK_PIECES) == kingside_castling_possible?(previous_board, 63, 60, BLACK_PIECES))
  end

  def queenside_castling_possible?(current_board, rook_tile_n, king_tile_n, color_piece)
    current_board.board[rook_tile_n].piece != " " &&
    current_board.board[king_tile_n].piece != " " &&
    current_board.board[rook_tile_n].piece.piece == color_piece[0] &&
    (rook_tile_n + 1..king_tile_n - 1).all? { |n| current_board.board[n].piece == " " } &&
    current_board.board[king_tile_n].piece.piece == color_piece[4] &&
    current_board.board[rook_tile_n].piece.time_first_move == 0 &&
    current_board.board[king_tile_n].piece.time_first_move == 0
  end

  def kingside_castling_possible?(current_board, rook_tile_n, king_tile_n, color_piece)
    current_board.board[rook_tile_n].piece != " " &&
    current_board.board[king_tile_n].piece != " " &&
    current_board.board[rook_tile_n].piece.piece == color_piece[0] &&
    (king_tile_n + 1..rook_tile_n - 1).all? { |n| current_board.board[n].piece == " " } &&
    current_board.board[king_tile_n].piece.piece == color_piece[4] &&
    current_board.board[rook_tile_n].piece.time_first_move == 0 &&
    current_board.board[king_tile_n].piece.time_first_move == 0
  end

  def black_enpassant_down_right_possible?(current_board, color_piece, turn_count)
    (24..30).each do |pawn_location|  
      return pawn_location if (current_board.board[pawn_location].piece != " " && current_board.board[pawn_location].piece.piece == BLACK_PIECES[5]) &&
      (current_board.board[pawn_location + 1].piece != " " && current_board.board[pawn_location + 1].piece.piece == WHITE_PIECES[5]) &&
      current_board.board[pawn_location + 1 - 8].piece == " " &&
      current_board.board[pawn_location + 1].piece.time_first_move == turn_count
    end
    nil
  end

  def black_enpassant_down_left_possible?(current_board, color_piece, turn_count)
    (25..31).each do |pawn_location|  
      return pawn_location if (current_board.board[pawn_location].piece != " " && current_board.board[pawn_location].piece.piece == BLACK_PIECES[5]) &&
      (current_board.board[pawn_location - 1].piece != " " && current_board.board[pawn_location - 1].piece.piece == WHITE_PIECES[5]) &&
      current_board.board[pawn_location - 1 - 8].piece == " " &&
      current_board.board[pawn_location - 1].piece.time_first_move == turn_count
    end
    nil
  end

  def white_enpassant_up_right_possible?(current_board, color_piece, turn_count)
    (32..38).each do |pawn_location|  
      return pawn_location if (current_board.board[pawn_location].piece != " " && current_board.board[pawn_location].piece.piece == WHITE_PIECES[5]) &&
      (current_board.board[pawn_location + 1].piece != " " && current_board.board[pawn_location + 1].piece.piece == BLACK_PIECES[5]) &&
      current_board.board[pawn_location + 1 + 8].piece == " " &&
      current_board.board[pawn_location + 1].piece.time_first_move == turn_count
    end
    nil
  end

  def white_enpassant_up_left_possible?(current_board, color_piece, turn_count)
    (33..39).each do |pawn_location|  
      return pawn_location if (current_board.board[pawn_location].piece != " " && current_board.board[pawn_location].piece.piece == WHITE_PIECES[5]) &&
      (current_board.board[pawn_location - 1].piece != " " && current_board.board[pawn_location - 1].piece.piece == BLACK_PIECES[5]) &&
      current_board.board[pawn_location - 1 + 8].piece == " " &&
      current_board.board[pawn_location - 1].piece.time_first_move == turn_count
    end
    nil
  end

  def enpassant_possible(current_board, color_piece, turn_count)
    black_enpassant_down_right_possible?(current_board, color_piece, turn_count) ||
    black_enpassant_down_left_possible?(current_board, color_piece, turn_count) ||
    white_enpassant_up_right_possible?(current_board, color_piece, turn_count) ||
    white_enpassant_up_left_possible?(current_board, color_piece, turn_count)
  end
end