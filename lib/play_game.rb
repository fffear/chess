$: << "#{File.expand_path('../chessboard', __FILE__)}"
$: << "#{File.expand_path('../chess_pieces', __FILE__)}"

require 'chessboard'
require 'rook'
require 'knight'
require 'bishop'
require 'queen'
require 'king'
require 'pawn'

class Chess
  attr_accessor :board

  def initialize
    @board = Chessboard.new
  end

  def generate_starting_board
    generate_white_pieces
    generate_black_pieces
  end

  private
  def generate_white_pieces
    (0..15).each do |n|
      @board.chessboard[n].piece = Rook.new("\u2656".encode('utf-8')) if n.zero? || n == 7
      @board.chessboard[n].piece = Knight.new("\u2658".encode('utf-8')) if n == 1 || n == 6
      @board.chessboard[n].piece = Bishop.new("\u2657".encode('utf-8')) if n == 2 || n == 5
      @board.chessboard[n].piece = Queen.new("\u2655".encode('utf-8')) if n == 3
      @board.chessboard[n].piece = King.new("\u2654".encode('utf-8')) if n == 4
      @board.chessboard[n].piece = WhitePawn.new("\u2659".encode('utf-8')) if n >= 8
    end
  end

  def generate_black_pieces
    (48..63).each do |n|
      @board.chessboard[n].piece = Rook.new("\u265C".encode('utf-8')) if n == 63 || n == 56
      @board.chessboard[n].piece = Knight.new("\u265E".encode('utf-8')) if n == 62 || n == 57
      @board.chessboard[n].piece = Bishop.new("\u265D".encode('utf-8')) if n == 61 || n == 58
      @board.chessboard[n].piece = Queen.new("\u265B".encode('utf-8')) if n == 59
      @board.chessboard[n].piece = King.new("\u265A".encode('utf-8')) if n == 60
      @board.chessboard[n].piece = BlackPawn.new("\u265F".encode('utf-8')) if n <= 55
    end
  end

end


#board = Chessboard.new
#p board.chessboard[0].piece = Rook.new("\u265C".encode('utf-8'))

chess = Chess.new
chess.generate_starting_board
chess.board.print_board