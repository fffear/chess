# # White Pawn
# p "\u2659".encode('utf-8')

# # Black Pawn
# p "\u265F".encode('utf-8')

$: << "#{File.expand_path('../../chessboard', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
require 'chessboard'
require 'coordinates'
require 'chess_pieces'

class Pawn
  include Coordinates
  include ChessPieces
  attr_reader :piece, :starting_positions
  attr_accessor :move_count

  def initialize(piece)
    @piece = piece
    @starting_positions = Chessboard.new.board
    @move_count = 0
    generate_moves
  end

  def all_possible_moves
    @starting_positions
  end

  def generate_moves_white
    (8...16).each do |n|
      [8, 16].each { |num| add_adjacent_node(n, num) }
      add_take_opponent_move(n, 9, 7)
    end

    (16...56).each do |n|
      add_adjacent_node(n, 8)
      add_take_opponent_move(n, 9, 7)
    end
  end

  def generate_moves_black
    (48...56).each do |n|
      [-8, -16].each { |num| add_adjacent_node(n, num) }
      add_take_opponent_move(n, -7, -9)
    end

    (8...48).each do |n|
      add_adjacent_node(n, -8)
      add_take_opponent_move(n, -7, -9)
    end
  end

  def generate_moves
    #generate_moves_black if (48..55).include? convert_coordinates_to_num(@original_position[0] + @original_position[1].to_s)  
    #generate_moves_white if (8..15).include? convert_coordinates_to_num(@original_position[0] + @original_position[1].to_s) 
    generate_moves_black if piece == "\u265F".encode('utf-8')
    generate_moves_white if piece == "\u2659".encode('utf-8')

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

#class WhitePawn < Pawn
#  def generate_moves_white
#    (8...16).each do |n|
#      [8, 16].each { |num| add_adjacent_node(n, num) }
#      add_take_opponent_move(n, 9, 7)
#    end
#
#    (16...56).each do |n|
#      add_adjacent_node(n, 8)
#      add_take_opponent_move(n, 9, 7)
#    end
#  end
#end

#class BlackPawn < Pawn
#  def generate_moves_black
#    (48...56).each do |n|
#      [-8, -16].each { |num| add_adjacent_node(n, num) }
#      add_take_opponent_move(n, -7, -9)
#    end
#
#    (8...48).each do |n|
#      add_adjacent_node(n, -8)
#      add_take_opponent_move(n, -7, -9)
#    end
#  end
#end

#pawn = Pawn.new("\u2659".encode('utf-8'), 1)
#p pawn

#pawn2 = BlackPawn.new("\u265F".encode('utf-8'))
#pawn2.generate_moves
#p pawn2.all_possible_moves[8]
