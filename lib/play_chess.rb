$: << "#{File.expand_path("..", __FILE__)}"

require 'chess'

File.open("../chess_heading.txt", "r") { |file| puts file.read }
puts "\nWelcome to Fffear's Chess!"
puts "\nThis is a command line chess game played between 2 human players."
puts "\nThe game prevents you from making illegal moves, and declares check and checkmate in appropriate situations."
puts "\nThe game will also declare stalemate, prompt you when threefold repetition occurs, and respect the 50 move draw rule."
puts "\nYou will also be prompted for the option to resign and propose a draw."
puts "\nYou will also have the option of saving the game after each turn."
puts "\nThere will be instructions along the way to help you enter the correct decisions.\n\n"

chess = Chess.new
chess.generate_starting_board
chess.play_game
