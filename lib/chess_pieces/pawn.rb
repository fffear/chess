# # White Pawn
# p "\u2659".encode('utf-8')

# # Black Pawn
# p "\u265F".encode('utf-8')

$: << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'chessboard'

class Pawn
  attr_reader :piece, :starting_positions, :original_position
  attr_accessor :move_count

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.chessboard
    generate_moves
    @move_count = 0
  end

  def all_possible_moves
    @starting_positions
  end

  private
  def add_take_opponent_move(n, right, left)
    @starting_positions[n].possible_moves << n + right if n % 8 != 7
    @starting_positions[n].possible_moves << n + left if n % 8 != 0
  end

  def add_adjacent_node(n, num)
    starting_positions[n].possible_moves << n + num
  end
end

class WhitePawn < Pawn
  def generate_moves
    (8...16).each do |n|
      [8, 16].each { |num| add_adjacent_node(n, num) }
      add_take_opponent_move(n, 9, 7)
    end

    (16...56).each do |n|
      add_adjacent_node(n, 8)
      add_take_opponent_move(n, 9, 7)
    end
  end
end

class BlackPawn < Pawn
  def generate_moves
    (48...56).each do |n|
      [-8, -16].each { |num| add_adjacent_node(n, num) }
      add_take_opponent_move(n, -7, -9)
    end

    (8...48).each do |n|
      add_adjacent_node(n, -8)
      add_take_opponent_move(n, -7, -9)
    end
  end
end

pawn = WhitePawn.new("\u2659".encode('utf-8'))
p pawn.all_possible_moves[8]

#pawn2 = BlackPawn.new("\u265F".encode('utf-8'))
#pawn2.generate_moves
#p pawn2.all_possible_moves[8]