$: << "#{File.expand_path('../../modules', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../check_checkmate', __FILE__)}"

require 'possible_moves'
require 'chess_pieces'
require 'coordinates'
require 'check'

class FiftyMoveDraw
  attr_accessor :fifty_move_count, :pawn_positions_before_full_move, :pawn_positions_after_full_move,
                :no_of_pieces_before_full_move, :no_of_pieces_after_full_move

  def initialize(pawn_positions_before_full_move, pawn_positions_after_full_move, no_of_pieces_before_full_move, no_of_pieces_after_full_move)
    @pawn_positions_before_full_move = pawn_positions_before_full_move
    @pawn_positions_after_full_move = pawn_positions_after_full_move
    @no_of_pieces_before_full_move = no_of_pieces_before_full_move
    @no_of_pieces_after_full_move = no_of_pieces_after_full_move
    @fifty_move_count = 0
  end

  def fifty_move_rule_draw?
    (@pawn_positions_before_full_move - @pawn_positions_after_full_move).length == 0 &&
    (@number_of_pieces_before_full_move == @number_of_pieces_after_full_move)
  end

  def count_fifty_move_rule
    (fifty_move_rule_draw?) ? @fifty_move_count += 1 : @fifty_move_count = 0
  end

  def compute
    p count_fifty_move_rule
    if @fifty_move_count == 50
      puts "It has been 50 moves since either the last piece has been taken, or a pawn has moved."
      puts "The game is a draw."
      return true
    end
    false
  end

end