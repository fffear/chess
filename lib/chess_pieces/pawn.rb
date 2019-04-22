# # White Pawn
# p "\u2659".encode('utf-8')

# # Black Pawn
# p "\u265F".encode('utf-8')

$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'generate_moves'

class Pawn
  attr_reader :piece, :starting_positions, :original_position
  attr_accessor :move_count

  include GenerateMoves

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
    @move_count = 0
  end

  def all_possible_moves
    @starting_positions
  end

  private
  def add_take_opponent_move(n, right, left)
    @starting_positions[n].possible_moves << @starting_positions[n + right].coordinates if n % 8 != 7
    @starting_positions[n].possible_moves << @starting_positions[n + left].coordinates if n % 8 != 0
  end
end

class WhitePawn < Pawn
  def generate_moves
    (8...16).each do |n|
      [8, 16].each do |num|
        starting_positions[n].possible_moves << starting_positions[n + num].coordinates
      end
      add_take_opponent_move(n, 9, 7)
    end

    (16...56).each do |n|
      @starting_positions[n].possible_moves << @starting_positions[n + 8].coordinates
      add_take_opponent_move(n, 9, 7)
    end
  end
end

class BlackPawn < Pawn
  def generate_moves
    (48...56).each do |n|
      [-8, -16].each do |num|
        @starting_positions[n].possible_moves << @starting_positions[n + num].coordinates  
      end
      add_take_opponent_move(n, -7, -9)
    end

    (8...48).each do |n|
      @starting_positions[n].possible_moves << @starting_positions[n - 8].coordinates
      add_take_opponent_move(n, -7, -9)
    end
  end
end

#pawn = WhitePawn.new("\u2659".encode('utf-8'))
#pawn.generate_moves
#p pawn.all_possible_moves[8..55]

pawn2 = BlackPawn.new("\u265F".encode('utf-8'))
pawn2.generate_moves
p pawn2.all_possible_moves[48..55]