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

class Chess
  include ChessPieces
  include Coordinates
  attr_accessor :board, :player_1, :player_2, :turn_count, :white_king_position, :black_king_position, :white_pieces_location,
                :black_pieces_location, :board_before_move, :origin, :destination, :board_history, :pawn_positions_before_full_move,
                :pawn_positions_after_full_move, :no_of_pieces_before_full_move, :no_of_pieces_after_full_move,
                :fifty_move_count, :filename

  def initialize
    @board = Chessboard.new
    @player_1 = Player.new("white", WHITE_PIECES, BLACK_PIECES)
    @player_2 = Player.new("black", BLACK_PIECES, WHITE_PIECES)
    @turn_count = 0
    @board_history = []
    @fifty_move_count = 0
    @filename = nil
  end

  def generate_starting_board
    generate_white_pieces
    generate_black_pieces
  end

  def ensure_valid_origin(player)
    puts "#{player}, please enter the coordinates of the piece you would like to move"
    @origin = gets.chomp
    puts "You have entered an invalid coordinate. Please try again." unless valid_coordinate?(@origin)
  end

  def ensure_valid_destination(player)
    puts "#{player}, please enter the coordinates on the board you would like to move the selected piece to"
    @destination = gets.chomp
    puts "You have entered an invalid coordinate. Please try again." unless valid_coordinate?(@destination)
  end

  def resign_game?(player1, player2)
    loop do
      puts "#{player1}, do you want to resign? (y/n)"
      resign_answer = gets.chomp
      if ["yes", "y", "no", "n"].none? { |ans| resign_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      puts "#{player1} has resigned. #{player2} wins!" if ["yes", "y"].one? { |ans| resign_answer == ans }
      return false if ["no", "n"].one? { |ans| resign_answer == ans }
      return true
    end
  end

  def propose_draw(player1, player2)
    loop do
      puts "#{player1}, do you want to propose a draw to you're opponent? (y/n)"
      propose_draw_answer = gets.chomp.downcase
      if ["yes", "y", "no", "n"].none? { |ans| propose_draw_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      return accept_draw_proposal?(player1, player2) if ["yes", "y"].one? { |ans| propose_draw_answer == ans }
      break if ["no", "n"].one? { |ans| propose_draw_answer == ans }
    end
  end

  def accept_draw_proposal?(player1, player2)
    loop do
      puts "#{player1} has proposed a draw. #{player2}, do you accept the proposal? (y/n)"
      accept_draw_answer = gets.chomp.downcase
      if ["yes", "y", "no", "n"].none? { |ans| accept_draw_answer == ans }
        puts "Please enter a valid answer."
        redo
      end
      puts "#{player2} has accepted your proposal to draw. The game is a draw." if ["yes", "y"].one? { |ans| accept_draw_answer == ans }
      return false if ["no", "n"].one? { |ans| accept_draw_answer == ans }
      return true
    end
  end

  def load_saved_game
    return if no_saved_games? || !(File.exists?("../saved_games"))
    loop do
      puts "Do you want to load a saved game?"
      load_game_answer = gets.chomp.downcase
      if ["yes", "y", "no", "n"].none? { |ans| ans == load_game_answer }
        puts "Invalid answer."
        redo
      elsif ["yes", "y"].one? { |ans| ans == load_game_answer }
        select_game_to_load
        break
      end
      break if ["no", "n"].one? { |ans| ans == load_game_answer }
    end
  end

  def save_game
    loop do
      puts "Do you want to save the game? (y/n)"
      save_game_answer = gets.chomp.downcase
      if ["yes", "y", "no", "n"].none? { |ans| ans == save_game_answer }
        puts "Invalid answer."
        redo
      elsif ["yes", "y"].one? { |ans| ans == save_game_answer }
        determine_saved_file_name
        break
      elsif ["no", "n"].one? { |ans| ans == save_game_answer }
        break
      end
    end
  end

  def determine_saved_file_name
    loop do
      if @filename != nil
        puts "This game was previously saved as '#{@filename}.txt'.\nDo you want to save under the same name? (y/n)"
        answer = gets.chomp
        if ["yes", "y", "no", "n"].none? { |ans| ans == answer }
          puts "Invalid answer."
          redo
        elsif ["yes", "y"].one? { |ans| ans == answer }
          File.open("../saved_games/#{@filename}.txt", "w") { |file| file.puts marshal_save_game }
          puts "\nYou have saved the game as '#{@filename}.txt'."
          return
        end
      end
      break
    end
    name_saved_file
  end

  def name_saved_file
    Dir.mkdir("../saved_games") unless File.exists?("../saved_games")
    puts "Please name the saved file."
    saved_fname = gets.chomp
    @filename = saved_fname
    File.open("../saved_games/#{saved_fname}.txt", "w") { |file| file.puts marshal_save_game }
    puts "\nYou have saved the game as '#{saved_fname}.txt'."
  end

  def marshal_save_game
    Marshal::dump({
                    :board => @board,
                    :board_history => @board_history,
                    :turn_count => @turn_count,
                    :fifty_move_count => @fifty_move_count,
                    :pawn_positions_before_full_move => @pawn_positions_before_full_move,
                    :pawn_positions_after_full_move => @pawn_positions_after_full_move,
                    :no_of_pieces_before_full_move => @no_of_pieces_before_full_move,
                    :no_of_pieces_after_full_move => @no_of_pieces_after_full_move,
                    :filename => @filename
                  })
  end

  def select_game_to_load
    loop do
      puts "Please select the number of the file you would like to load:"
      Dir.glob("../saved_games/*").each_with_index do |file, idx|
        puts file.gsub("../saved_games/", "#{idx + 1}- ")
      end
      number_of_file = gets.chomp
      if number_of_file =~ /\D+/
        puts "Invalid response entered."
        redo
      elsif number_of_file =~ /\d+/
        if number_of_file.to_i > Dir.glob("../saved_games/*").length
          puts "There is no file corresponding to that number."
          redo
        elsif number_of_file.to_i <= Dir.glob("../saved_games/*").length && number_of_file.to_i > 0
          File.open(Dir.glob("../saved_games/*")[number_of_file.to_i - 1], "r") { |file| from_marshal_string(file) }
          break
        end
      end
    end
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

  def play_game
    @board_history << Marshal::dump(@board)
    load_saved_game
    loop do
      if @turn_count.even?
        break if white_player_turn.call
      elsif @turn_count.odd?
        break if black_player_turn.call
      end
    end
  end

  private
  #def generate_starting_board
  #  generate_white_pieces
  #  generate_black_pieces
  #end

  def ensure_valid_origin_and_destination(player)
    reset_origin_and_destination
    ensure_valid_origin(player) until !@origin.nil? && valid_coordinate?(@origin)
    ensure_valid_destination(player) until !@destination.nil? && valid_coordinate?(@destination)
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

  def white_player_turn
    lambda do
      white_player_action
      return true if game_end_conditions_after_white_move?
      update_board_history_and_save_game_after_white_action
    end
  end

  def black_player_turn
    lambda do
      black_player_action
      return true if game_end_conditions_after_black_move?
      update_board_history_and_save_game_after_black_action
    end
  end

  def white_player_action
    @board_before_move = Marshal::dump(@board)
    white_move
    @turn_count += 1
    board.print_board
  end

  def update_board_history_and_save_game_after_white_action
    @board_history << Marshal::dump(@board)
    save_game
  end

  def black_player_action
    @board_before_move = Marshal::dump(@board)
    black_move
    @turn_count += 1
    board.print_board
  end

  def update_board_history_and_save_game_after_black_action
    @board_history.clear if @no_of_pieces_before_full_move > @no_of_pieces_after_full_move
    @board_history << Marshal::dump(@board)
    save_game
  end

  def no_saved_games?
    File.exists?("../saved_games") && Dir.glob("../saved_games/*").length == 0
  end

  def checkmate?(color_pieces, turn_count)
    if CheckMate.new(@board, color_pieces, turn_count).compute
      puts "Checkmate for Black player. Black player loses." if color_pieces == BLACK_PIECES
      puts "Checkmate for White player. White player loses." if color_pieces == WHITE_PIECES
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

  def tiles_with_chess_pieces(current_board)
    piece_positions = []
    current_board.board.each_with_index { |tile, idx| piece_positions << idx if tile.piece != " " }
    piece_positions
  end

  def fifty_moves_reached?
    @fifty_move_count = FiftyMoveDraw.new(@pawn_positions_before_full_move, @pawn_positions_after_full_move, @no_of_pieces_before_full_move, @no_of_pieces_after_full_move, @fifty_move_count).update_fifty_move_count
    FiftyMoveDraw.new(@pawn_positions_before_full_move, @pawn_positions_after_full_move, @no_of_pieces_before_full_move, @no_of_pieces_after_full_move, @fifty_move_count).compute
  end

  def move_piece(origin, destination, player)
    if player == 1
      player_1.move_piece(origin, destination, @board, player_1.pieces, player_2.pieces, @turn_count)
    else
      player_2.move_piece(origin, destination, @board, player_2.pieces, player_1.pieces, @turn_count)
    end
  end

  def from_marshal_string(string)
    data = Marshal::load(string)
    update_instance_variables(data[:board], data[:board_history], data[:turn_count], data[:fifty_move_count],
                              data[:pawn_positions_before_full_move], data[:pawn_positions_after_full_move],
                              data[:no_of_pieces_before_full_move], data[:no_of_pieces_after_full_move],
                              data[:filename])
  end

  def update_instance_variables(board, board_history, turn_count, fifty_move_count, pawn_positions_before_full_move,
                                pawn_positions_after_full_move, no_of_pieces_before_full_move,
                                no_of_pieces_after_full_move, filename)
    @board = board
    @board_history = board_history
    @turn_count = turn_count
    @fifty_move_count = fifty_move_count
    @pawn_positions_before_full_move = pawn_positions_before_full_move
    @pawn_positions_after_full_move = pawn_positions_after_full_move
    @no_of_pieces_before_full_move = no_of_pieces_before_full_move
    @no_of_pieces_after_full_move = no_of_pieces_after_full_move
    @filename = filename
  end

  def king_in_check?(board, color_of_own_piece)
    Check.new(board, color_of_own_piece).compute
  end

  def player_in_check?(color_pieces)
    if color_pieces == BLACK_PIECES && king_in_check?(board, color_pieces) && !black_checkmated?
      puts "Black King in Check."
      return true
    elsif color_pieces == WHITE_PIECES && king_in_check?(board, color_pieces)
      puts "White King in Check."
      return true
    end
    false
  end

  def moved_into_check?(color_pieces)
    if king_in_check?(@board, color_pieces)
      puts "You can't move into Check."
      return true
    end
    false
  end

  def black_checkmated?
    if CheckMate.new(board, BLACK_PIECES, @turn_count).compute
      puts "Black player has been checkmated. Black player loses."
      return true
    end
    false
  end

  def white_checkmated?
    if CheckMate.new(board, WHITE_PIECES, @turn_count).compute
      puts "White player has been checkmated. White player loses."
      return true
    end
    false
  end

  def stalemate?(color_pieces)
    if color_pieces == BLACK_PIECES && Stalemate.new(board, color_pieces, @turn_count).compute
      puts "It is a stalemate for black"
      return true
    elsif color_pieces == WHITE_PIECES && Stalemate.new(board, color_pieces, @turn_count).compute
      puts "It is a stalemate for white"
      return true
    end
    false
  end

  def claim_draw_due_to_threefold_repetition?(player)
    ThreefoldRepetition.new(@board, @board_history, @turn_count).compute && claim_threefold_repetition_draw?(player)
  end

  def game_end_conditions_after_white_move?
    return true if black_checkmated?
    player_in_check?(BLACK_PIECES)
    return true if (claim_draw_due_to_threefold_repetition?("Black player") || stalemate?(BLACK_PIECES))
    return true if !king_in_check?(board, BLACK_PIECES) && (resign_game?("White player", "Black player") || propose_draw("White player", "Black player"))
    false
  end

  def game_end_conditions_after_black_move?
    return true if white_checkmated?
    player_in_check?(WHITE_PIECES)
    find_factors_of_fifty_move_draw_after_full_move
    return true if fifty_moves_reached?
    return true if (claim_draw_due_to_threefold_repetition?("White player") || stalemate?(BLACK_PIECES))
    return true if !king_in_check?(board, WHITE_PIECES) && (resign_game?("Black player", "White player") || propose_draw("Black player", "White player"))
    false
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

  def find_factors_of_fifty_move_draw_before_full_move
    @pawn_positions_before_full_move = find_pawn_positions
    @no_of_pieces_before_full_move = count_of_pieces
  end

  def find_factors_of_fifty_move_draw_after_full_move
    @pawn_positions_after_full_move = find_pawn_positions
    @no_of_pieces_after_full_move = count_of_pieces
  end

  def board_unchanged?
    if (tiles_with_chess_pieces(Marshal::load(@board_before_move)) - tiles_with_chess_pieces(@board)).length == 0
      puts "No piece has been moved."
      return true
    end
    false
  end

  def white_move
    loop do
      @board = Marshal::load(@board_before_move)
      find_factors_of_fifty_move_draw_before_full_move
      board.print_board
      ensure_valid_origin_and_destination("White player")
      move_piece(@origin, @destination, 1)
      redo if board_unchanged?
      break unless moved_into_check?(WHITE_PIECES)
    end
  end

  def black_move
    loop do
      @board = Marshal::load(@board_before_move)
      board.print_board
      ensure_valid_origin_and_destination("Black player")
      move_piece(@origin, @destination, 2)
      redo if board_unchanged?
      break unless moved_into_check?(BLACK_PIECES)
    end
  end
end


#board = Chessboard.new
#p board.chessboard[0].piece = Rook.new("\u265C".encode('utf-8'))

#chess = Chess.new
#chess.generate_starting_board
#chess.board.print_board


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

#chess.play_game

#p chess.board.board[35].piece.move_count
#p chess.board.board[8].piece.move_count

#chess.move_piece("d2", "d4", 1)
#chess.board.print_board
#p chess.board.board[16]
#[@start].piece.starting_positions[@start].possible_moves.include?(@final)
#p chess.board
