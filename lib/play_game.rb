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
require 'move_pawn'

class Chess
  include ChessPieces
  attr_accessor :board, :player_1, :player_2, :turn_count

  def initialize
    @board = Chessboard.new
    @player_1 = Player.new("white", WHITE_PIECES, BLACK_PIECES)
    @player_2 = Player.new("black", BLACK_PIECES, WHITE_PIECES)
    @turn_count = 0
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

  def take_turns
    loop do
      puts "Please enter the coordinates of the piece you would like to move"
      origin = gets.chomp
      puts "Please enter the coordinates on the board you would like to move the selected piece to"
      destination = gets.chomp
      @turn_count += 1
      move_piece(origin, destination, 1)
      board.print_board
      #puts "Time first move: #{board.board[27].piece.original_position}"
      break if @turn_count == 10

      puts "Please enter the coordinates of the piece you would like to move"
      origin = gets.chomp
      puts "Please enter the coordinates on the board you would like to move the selected piece to"
      destination = gets.chomp
      @turn_count += 1
      move_piece(origin, destination, 2)
      board.print_board


      #puts turn_count
      break if @turn_count == 10
    end
  end

  def move_piece(origin, destination, player)
    if player == 1
      player_1.move_piece(origin, destination, @board, player_1.pieces, player_2.pieces, @turn_count)
    else
      player_2.move_piece(origin, destination, @board, player_2.pieces, player_1.pieces, @turn_count)
    end
  end

  def vertical_move?(start, final)
    (final > start && final - start >= 8) || (final < start && start - final >= 8)
  end

  def horizontal_move?(start, final)
    (final > start && final - start <= 7) || (final < start && start - final <= 7)
  end

  private
  def generate_white_pieces
    (0..55).each do |n|
      #@board.board[n].piece = Rook.new(WHITE_PIECES[0]) if n.zero? || n == 7
      #@board.board[n].piece = Knight.new(WHITE_PIECES[1]) if n == 1 || n == 6
      #@board.board[n].piece = Bishop.new(WHITE_PIECES[2]) if n == 2 || n == 5
      #@board.board[n].piece = Queen.new(WHITE_PIECES[3]) if n == 3
      #@board.board[n].piece = King.new(WHITE_PIECES[4]) if n == 4
      #@board.board[n].piece = Pawn.new(WHITE_PIECES[5], convert_coordinates_to_num(@board.board[n].coordinates[0] + @board.board[n].coordinates[1].to_s)) if n == 50 #n >= 8 || n == 35
      #@board.board[n].piece = Pawn.new(WHITE_PIECES[5]) if n == 25
      #@board.board[n].piece = Knight.new(WHITE_PIECES[1]) if n == 34
    end
  end

  def generate_black_pieces
    (0..63).each do |n|
      @board.board[n].piece = Rook.new(BLACK_PIECES[0]) if n == 63 || n == 56
      @board.board[n].piece = Knight.new(BLACK_PIECES[1]) if n == 62 || n == 57
      @board.board[n].piece = Bishop.new(BLACK_PIECES[2]) if n == 61 || n == 58
      @board.board[n].piece = Queen.new(BLACK_PIECES[3]) if n == 59
      @board.board[n].piece = King.new(BLACK_PIECES[4]) if n == 60
      @board.board[n].piece = Pawn.new(BLACK_PIECES[5], convert_coordinates_to_num(@board.board[n].coordinates[0] + @board.board[n].coordinates[1].to_s)) if n == 12
    end
  end
end


#board = Chessboard.new
#p board.chessboard[0].piece = Rook.new("\u265C".encode('utf-8'))

#chess = Chess.new
#chess.generate_starting_board
#chess.board.print_board

#p chess.board.board[8].piece.move_count
#p chess.board.chessboard[0].piece #.starting_positions #[0].coordinates

#chess.take_turns

#p chess.board.board[35].piece.move_count
#p chess.board.board[8].piece.move_count

#chess.move_piece("d2", "d4", 1)
#chess.board.print_board
#p chess.board.board[16]
#[@start].piece.starting_positions[@start].possible_moves.include?(@final)
#p chess.board

