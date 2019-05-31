$: << "#{File.expand_path('../chessboard', __FILE__)}"
$: << "#{File.expand_path('../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../move_pieces', __FILE__)}"
$: << "#{File.expand_path('../player', __FILE__)}"
$: << "#{File.expand_path('../modules', __FILE__)}"
$: << "#{File.expand_path('../check_checkmate', __FILE__)}"
$: << "#{File.expand_path('../draw_conditions', __FILE__)}"

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
require 'coordinates'
require 'check'
require 'checkmate'
require 'stalemate'
require 'threefold_repetition'
require 'fifty_move_draw'

# insufficient checkmate material (knight, bishop)
# position move 3 times
# 50 rule move

class Chess
  include ChessPieces
  include Coordinates
  attr_accessor :board, :player_1, :player_2, :turn_count, :white_king_position, :black_king_position, :white_pieces_location,
                :black_pieces_location, :board_before_move, :origin, :destination, :board_history, :pawn_positions_before_full_move,
                :pawn_positions_after_full_move, :no_of_pieces_before_full_move, :no_of_pieces_after_full_move,
                :fifty_move_count

  def initialize
    @board = Chessboard.new
    @player_1 = Player.new("white", WHITE_PIECES, BLACK_PIECES)
    @player_2 = Player.new("black", BLACK_PIECES, WHITE_PIECES)
    @turn_count = 0
    @board_history = []
    @fifty_move_count = 0
  end

  def snapshot_before_move
    @board_before_move = @board
  end

  def reverse_move
    @board = @board_before_move
  end

  def generate_starting_board
    generate_white_pieces
    generate_black_pieces
  end

  def ensure_valid_origin
    puts "Please enter the coordinates of the piece you would like to move"
    @origin = gets.chomp
    puts "You have entered an invalid coordinate. Please try again." unless valid_coordinate?(@origin)
  end

  def ensure_valid_destination
    puts "Please enter the coordinates on the board you would like to move the selected piece to"
    @destination = gets.chomp
    puts "You have entered an invalid coordinate. Please try again." unless valid_coordinate?(@destination)
  end

  def ensure_valid_origin_and_destination
    ensure_valid_origin until !@origin.nil? && valid_coordinate?(@origin)
    ensure_valid_destination until !@destination.nil? && valid_coordinate?(@destination)
  end

  def reset_origin_and_destination
    @origin = nil
    @destination = nil
  end

  def valid_coordinate?(coordinate)
    return false unless LETTERS.one? { |l| l == coordinate[0] } && (1..8).include?(coordinate[1].to_i)
    return false if coordinate.length > 2
    true if LETTERS.one? { |l| l == coordinate[0] } && (1..8).include?(coordinate[1].to_i)
  end

  def take_turns
    #p count_of_pieces
    @board_history << Marshal::dump(@board)
    loop do
      @board_before_move = Marshal::dump(@board)
      loop do
        reset_origin_and_destination
        @board = Marshal::load(@board_before_move)
        p @pawn_positions_before_full_move = find_pawn_positions
        p @no_of_pieces_before_full_move = count_of_pieces
        board.print_board
        ensure_valid_origin_and_destination
        move_piece(@origin, @destination, 1)
        redo if @board.board[convert_coordinates_to_num(@destination)].piece == " "
        break unless king_in_check?(board, WHITE_PIECES)
        puts "You can't move into Check." if king_in_check?(board, WHITE_PIECES)
      end
      @turn_count += 1
      board.print_board
      break if ThreefoldRepetition.new(@board, @board_history, @turn_count).compute && claim_threefold_repetition_draw?("Black player")
      @board_history << Marshal::dump(@board)
      puts "Checkmate for Black player. Black player loses." if CheckMate.new(board, BLACK_PIECES, @turn_count).compute
      puts "Black King in Check." if king_in_check?(board, BLACK_PIECES)
      puts "It is a stalemate for black" if Stalemate.new(board, BLACK_PIECES, @turn_count).compute
      resign_game("White player", "Black player")
      propose_draw("White player", "Black player")
      # propose draw
      
      
      break if @turn_count == 10

      @board_before_move = Marshal::dump(@board)
      loop do
        reset_origin_and_destination
        @board = Marshal::load(@board_before_move)
        board.print_board
        ensure_valid_origin_and_destination
        move_piece(@origin, @destination, 2)
        redo if @board.board[convert_coordinates_to_num(@destination)].piece == " "
        break unless king_in_check?(board, BLACK_PIECES)
        puts "You can't move into Check." if king_in_check?(board, BLACK_PIECES)
      end
      @turn_count += 1
      board.print_board
      break if ThreefoldRepetition.new(@board, @board_history, @turn_count).compute && claim_threefold_repetition_draw?("White player")
      @board_history << Marshal::dump(@board)
      puts "Checkmate for White player. White player loses." if CheckMate.new(board, WHITE_PIECES, @turn_count).compute
      p @pawn_positions_after_full_move = find_pawn_positions
      p @no_of_pieces_after_full_move = count_of_pieces
      break if fifty_moves_reached?
      p @pawn_positions_before_full_move - @pawn_positions_after_full_move
      puts "White King in Check." if king_in_check?(board, WHITE_PIECES)
      puts "It is a stalemate" if Stalemate.new(board, WHITE_PIECES, @turn_count).compute
      resign_game("Black player", "White player")
      propose_draw("White player", "Black player")
      # propose draw
      break if @turn_count == 100
    end
  end

  def count_of_pieces
    @board.board.count { |tile| tile.piece != " " }
  end

  def find_pawn_positions
    pawn_positions = []
    @board.board.each_with_index do |tile, idx|
      pawn_positions << idx if tile.piece != " " && (tile.piece.piece == WHITE_PIECES[5] || tile.piece.piece == BLACK_PIECES[5])
    end
    pawn_positions
  end

  def fifty_moves_reached?
    FiftyMoveDraw.new(@pawn_positions_before_full_move, @pawn_positions_after_full_move, @no_of_pieces_before_full_move, @no_of_pieces_after_full_move).compute
  end

  def claim_threefold_repetition_draw?(player)
    loop do
      puts "The board has repeated 3 times. #{player}, do you want to claim a draw? (y/n)"
      claim_draw_answer = gets.chomp
      if ["yes", "y", "no", "n"].none? { |ans| claim_draw_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      puts "The game is a draw." if ["yes", "y"].one? { |ans| claim_draw_answer == ans }
      return false if ["no", "n"].one? { |ans| claim_draw_answer == ans }
      return true
    end
  end

  def resign_game(player1, player2)
    loop do
      puts "#{player1}, do you want to resign? (y/n)"
      resign_answer = gets.chomp
      if ["yes", "y", "no", "n"].none? { |ans| resign_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      puts "#{player1} has resigned. #{player2} wins!" if ["yes", "y"].one? { |ans| resign_answer == ans }
      break if ["no", "n"].one? { |ans| resign_answer == ans }
      break
    end
  end

  def propose_draw(player1, player2)
    loop do
      puts "#{player1}, do you want to propose a draw to you're opponent? (y/n)"
      propose_draw_answer = gets.chomp
      if ["yes", "y", "no", "n"].none? { |ans| propose_draw_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      accept_draw_proposal(player1, player2) if ["yes", "y"].one? { |ans| propose_draw_answer == ans }
      break if ["no", "n"].one? { |ans| propose_draw_answer == ans }
      break
    end
  end

  def accept_draw_proposal(player1, player2)
    loop do
      puts "#{player1} has proposed a draw. #{player2}, do you accept the proposal?"
      accept_draw_answer = gets.chomp
      if ["yes", "y", "no", "n"].none? { |ans| accept_draw_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      puts "#{player2} has accepted your proposal to draw. The game is a draw." if ["yes", "y"].one? { |ans| accept_draw_answer == ans }
      break if ["no", "n"].one? { |ans| accept_draw_answer == ans }
      break
    end
  end

  def move_piece(origin, destination, player)
    if player == 1
      player_1.move_piece(origin, destination, @board, player_1.pieces, player_2.pieces, @turn_count)
    else
      player_2.move_piece(origin, destination, @board, player_2.pieces, player_1.pieces, @turn_count)
    end
  end

  def same_as?(game_board)
    self.board.board 
  end

  private
  def king_in_check?(board, color_of_own_piece)
    Check.new(board, color_of_own_piece).compute
  end

  def generate_white_pieces
    (0..55).each do |n|
      @board.board[n].piece = Rook.new(WHITE_PIECES[0]) if n == 0 || n == 7
      #@board.board[n].piece = Knight.new(WHITE_PIECES[1]) if n == 46#n == 20 || n == 21 #|| n == 37
      #@board.board[n].piece = Bishop.new(WHITE_PIECES[2]) if n == 8
      #@board.board[n].piece = Queen.new(WHITE_PIECES[3]) if n == 8
      @board.board[n].piece = King.new(WHITE_PIECES[4]) if n == 4
      @board.board[n].piece = Pawn.new(WHITE_PIECES[5], n) if n == 45#n == 11 || n == 13
      #@board.board[n].piece = Pawn.new(WHITE_PIECES[5], convert_coordinates_to_num(@board.board[n].coordinates[0] + @board.board[n].coordinates[1].to_s)) if n == 50 #n >= 8 || n == 35
      @board.board[n].piece = Pawn.new(WHITE_PIECES[5], n) if n == 25
      #@board.board[n].piece = Knight.new(WHITE_PIECES[1]) if n == 34
    end
  end

  def generate_black_pieces
    (0..63).each do |n|
      @board.board[n].piece = Rook.new(BLACK_PIECES[0]) if n == 56 || n == 63
      #@board.board[n].piece = Knight.new(BLACK_PIECES[1]) if n == 34 #n == 59 || n == 61
      #@board.board[n].piece = Bishop.new(BLACK_PIECES[2]) if n == 61 #n == 51 || n == 53
      #@board.board[n].piece = Queen.new(BLACK_PIECES[3]) if n == 40
      @board.board[n].piece = King.new(BLACK_PIECES[4]) if n == 60
      @board.board[n].piece = Pawn.new(BLACK_PIECES[5], n) if n == 48
    end
  end
end


#board = Chessboard.new
#p board.chessboard[0].piece = Rook.new("\u265C".encode('utf-8'))

chess = Chess.new
chess.generate_starting_board
chess.board.print_board
#p chess.board.board
#board1 = Marshal::dump(chess.board)
#p Marshal::load(board1) === chess.board
#p chess.board.object_id
#p Marshal::load(board1).object_id
#chess.move_piece("a1", "b1", 1)
#chess.board.print_board

#chess.board.print_board

#p chess.board.board[0].piece.starting_positions[0]#.possible_moves

#p chess.board.board[8].piece.move_count
#p chess.board.chessboard[0].piece #.starting_positions #[0].coordinates

chess.take_turns

#p chess.board.board[35].piece.move_count
#p chess.board.board[8].piece.move_count

#chess.move_piece("d2", "d4", 1)
#chess.board.print_board
#p chess.board.board[16]
#[@start].piece.starting_positions[@start].possible_moves.include?(@final)
#p chess.board

