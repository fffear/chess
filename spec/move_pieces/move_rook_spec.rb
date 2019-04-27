$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"

require 'move_rook'
require 'play_game'
require 'chess_pieces'
require 'coordinates'

describe MoveRook do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:move_rook) {MoveRook.new(0, 0, chess.board, ChessPieces::WHITE_PIECES)}

  describe "#compute" do
    context "move vertically" do
      ("a".."h").each do |l|
        (2..8).each do |n|
          it "moves a rook from #{l}1 to #{l}#{n}" do
            start = convert_coordinates_to_num(generate_coordinates(1, l))
            finish = convert_coordinates_to_num(generate_coordinates(n, l))
            chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
            move_rook.origin = generate_coordinates(1, l)
            move_rook.destination = generate_coordinates(n, l)
            expect {move_rook.compute}.to change {move_rook.board.board[start]}.and change {move_rook.board.board[finish]}
          end
        end
      end

      context "fails to take a square which already has your own piece" do
        ("a".."h").each do |l|  
          it "start #{l}1 taking over #{l}7" do
            start = convert_coordinates_to_num(generate_coordinates(1, l))
            finish = convert_coordinates_to_num(generate_coordinates(7, l))
            chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
            chess.board.board[finish].piece = Knight.new("\u2658".encode('utf-8'))
            move_rook.origin = generate_coordinates(1, l)
            move_rook.destination = generate_coordinates(7, l)
            expect {move_rook.compute}.to output.to_stdout
          end
        end
      end

      context "fails to move to a square with a blocking piece" do
        ("a".."h").each do |l|  
          it "start #{l}1 taking over #{l}8 with a piece blocking the path" do
            start = convert_coordinates_to_num(generate_coordinates(1, l))
            finish = convert_coordinates_to_num(generate_coordinates(7, l))
            chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
            chess.board.board[finish].piece = Knight.new("\u2658".encode('utf-8'))
            move_rook.origin = generate_coordinates(1, l)
            move_rook.destination = generate_coordinates(8, l)
            expect {move_rook.compute}.to output.to_stdout
          end
        end
      end

      context "takes a square containing opponent's piece" do
        ("a".."h").each do |l|  
          it "start #{l}1 taking over #{l}7" do
            start = convert_coordinates_to_num(generate_coordinates(1, l))
            finish = convert_coordinates_to_num(generate_coordinates(7, l))
            chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
            chess.board.board[finish].piece = Knight.new("\u265E".encode('utf-8'))
            move_rook.origin = generate_coordinates(1, l)
            move_rook.destination = generate_coordinates(7, l)
            expect {move_rook.compute}.to change {move_rook.board.board[start]}.and change {move_rook.board.board[finish]}
          end
        end
      end
    end
  end

  context "move horizontally" do
    (1..8).each do |n|
      ("b".."h").each do |l|
        it "moves a rook from a#{n} to #{l}#{n}" do
          start = convert_coordinates_to_num(generate_coordinates(n, "a"))
          finish = convert_coordinates_to_num(generate_coordinates(n, l))
          chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
          move_rook.origin = generate_coordinates(n, "a")
          move_rook.destination = generate_coordinates(n, l)
          expect {move_rook.compute}.to change {move_rook.board.board[start]}.and change {move_rook.board.board[finish]}
        end
      end
    end

    context "fails to take a square which already has your own piece" do
      (1..8).each do |n|  
        it "start a#{n} taking over g#{n}" do
          start = convert_coordinates_to_num(generate_coordinates(n, "a"))
          finish = convert_coordinates_to_num(generate_coordinates(n, "g"))
          chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
          chess.board.board[finish].piece = Knight.new("\u2658".encode('utf-8'))
          move_rook.origin = generate_coordinates(n, "a")
          move_rook.destination = generate_coordinates(n, "g")
          expect {move_rook.compute}.to output.to_stdout
        end
      end
    end

    context "fails to move to a square with a blocking piece" do
      (1..8).each do |n|  
        it "start a#{n} taking over h#{n} with a piece blocking the path" do
          start = convert_coordinates_to_num(generate_coordinates(n, "a"))
          finish = convert_coordinates_to_num(generate_coordinates(n, "g"))
          chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
          chess.board.board[finish].piece = Knight.new("\u2658".encode('utf-8'))
          move_rook.origin = generate_coordinates(n, "a")
          move_rook.destination = generate_coordinates(n, "h")
          expect {move_rook.compute}.to output.to_stdout
        end
      end
    end

    context "takes a square containing opponent's piece" do
      (1..8).each do |n|  
        it "start a#{n} taking over g#{n}" do
          start = convert_coordinates_to_num(generate_coordinates(n, "a"))
          finish = convert_coordinates_to_num(generate_coordinates(n, "g"))
          chess.board.board[start].piece = Rook.new("\u2656".encode('utf-8'))
          chess.board.board[finish].piece = Knight.new("\u265E".encode('utf-8'))
          move_rook.origin = generate_coordinates(n, "a")
          move_rook.destination = generate_coordinates(n, "g")
          expect {move_rook.compute}.to change {move_rook.board.board[start]}.and change {move_rook.board.board[finish]}
        end
      end
    end
  end
end