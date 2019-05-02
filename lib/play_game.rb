$: << "#{File.expand_path('../chessboard', __FILE__)}"
$: << "#{File.expand_path('../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../player', __FILE__)}"

require 'chessboard'
require 'rook'
require 'knight'
require 'bishop'
require 'queen'
require 'king'
require 'pawn'
require 'player'
require 'chess_pieces'
require 'move_rook'
require 'move_knight'
require 'move_bishop'
require 'move_queen'
require 'move_king'

class Chess
  include ChessPieces
  attr_accessor :board, :player_1, :player_2

  def initialize
    @board = Chessboard.new
    @player_1 = Player.new("white", WHITE_PIECES)
    @player_2 = Player.new("black", BLACK_PIECES)
  end

  def generate_starting_board
    generate_white_pieces
    generate_black_pieces
  end

  def convert_coordinates_to_num(coordinates)
    letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    (coordinates[1].to_i - 1) * 8 + letters.index(coordinates[0])
  end

  def valid_coordinate?(coordinate)
    letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    return false unless letters.one? { |l| l == coordinate[0] } && (1..8).include?(coordinate[1].to_i)
    return false if coordinate.length > 2
    if letters.one? { |l| l == coordinate[0] } && (1..8).include?(coordinate[1].to_i)
      true
    end
  end

  def move_piece(origin, destination)
    player_2.move_piece(origin, destination, @board, player_2.pieces)
  end

  def vertical_move?(start, final)
    (final > start && final - start >= 8) || (final < start && start - final >= 8)
  end

  def horizontal_move?(start, final)
    (final > start && final - start <= 7) || (final < start && start - final <= 7)
  end

  private
  def generate_white_pieces
    (0..63).each do |n|
      @board.board[n].piece = Queen.new(BLACK_PIECES[4]) if n == 15  #n.zero? # || n == 7
      @board.board[n].piece = Knight.new(WHITE_PIECES[1]) if n == 35 #|| n == 6
      
      #@board.chessboard[n].piece = Bishop.new("\u2657".encode('utf-8')) if n == 2 || n == 5
      #@board.chessboard[n].piece = Queen.new("\u2655".encode('utf-8')) if n == 3
      #@board.chessboard[n].piece = King.new("\u2654".encode('utf-8')) if n == 4
      #@board.chessboard[n].piece = WhitePawn.new("\u2659".encode('utf-8')) if n >= 8
    end
  end

  def generate_black_pieces
    #(48..63).each do |n|
    #  @board.chessboard[n].piece = Rook.new("\u265C".encode('utf-8')) if n == 63 || n == 56
    #  @board.chessboard[n].piece = Knight.new("\u265E".encode('utf-8')) if n == 62 || n == 57
    #  @board.chessboard[n].piece = Bishop.new("\u265D".encode('utf-8')) if n == 61 || n == 58
    #  @board.chessboard[n].piece = Queen.new("\u265B".encode('utf-8')) if n == 59
    #  @board.chessboard[n].piece = King.new("\u265A".encode('utf-8')) if n == 60
    #  @board.chessboard[n].piece = BlackPawn.new("\u265F".encode('utf-8')) if n <= 55
    #end
  end
end


#board = Chessboard.new
#p board.chessboard[0].piece = Rook.new("\u265C".encode('utf-8'))

chess = Chess.new
chess.generate_starting_board
chess.board.print_board
#p chess.board.chessboard[0].piece #.starting_positions #[0].coordinates
chess.move_piece("h2", "i2")
chess.board.print_board
#[@start].piece.starting_positions[@start].possible_moves.include?(@final)
#p chess.board

