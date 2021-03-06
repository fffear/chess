$: << "#{File.expand_path('../../chessboard', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"

require 'chessboard'
require 'coordinates'
require 'chess_pieces'

class Pawn
  include Coordinates
  include ChessPieces
  attr_reader :piece, :starting_positions, :original_position
  attr_accessor :move_count, :time_first_move

  def initialize(piece, original_position)
    @piece = piece
    @starting_positions = Chessboard.new.board
    @move_count = 0
    @time_first_move = 0
    @original_position = original_position
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