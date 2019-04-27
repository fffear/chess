$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"

require 'move_knight'
require 'play_game'
require 'chess_pieces'
require 'coordinates'

describe MoveKnight do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:move_knight) {MoveKnight.new(0, 0, chess.board, ChessPieces::WHITE_PIECES)}

  def generate_blocking_piece(tile_num, shift_factor)
    chess.board.board[tile_num + shift_factor].piece = Rook.new("\u265C".encode('utf-8'))
  end

  def generate_blocking_pieces(tile_num, *shift_factor)
    shift_factor.each { |n| generate_blocking_piece(tile_num, n) }
  end

  def generate_start_and_finish_tile_num(n, l, shift_factor)
    start = convert_coordinates_to_num(generate_coordinates(n, l))
    finish = start + shift_factor
    {start: start, finish: finish}
  end

  def input_knight(tile_num, knight_piece)
    chess.board.board[tile_num].piece = Knight.new(knight_piece)
  end

  def set_origin_and_destination_coordinates(n, l, dest_tile_num)
    move_knight.origin = generate_coordinates(n, l)
    move_knight.destination = convert_num_to_coordinates(dest_tile_num)
  end

  def generate_test_pieces(start_num, finish_num, shift_factor, n, l, blocking_pieces, knight_piece)
    input_knight(start_num, knight_piece)
    generate_blocking_pieces(start_num, blocking_pieces[0], blocking_pieces[1], blocking_pieces[2], shift_factor) # shift factor array
    set_origin_and_destination_coordinates(n, l, finish_num)
  end

  describe "#compute" do
    context "move knight 2 tiles up 1 tile right, jump over other pieces, and takes opponents piece" do
      (1..6).each do |n|
        ("a".."g").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next}#{n + 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 17)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 17, n, l, [1, 8, 9], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile up 2 tiles right, jump over other pieces, and takes opponents piece" do
      (1..7).each do |n|
        ("a".."f").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next.next}#{n + 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 10)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 10, n, l, [1, 8, 9], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end
 
    context "move knight 2 tiles up 1 tile left, jump over other pieces, and takes opponents piece" do
      (1..6).each do |n|
        ("b".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 1).chr}#{n + 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 15)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 15, n, l, [-1, 7, 8], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile up 2 tiles left, jump over other pieces, and takes opponents piece" do
      (1..7).each do |n|
        ("c".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 2).chr}#{n + 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 6)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 6, n, l, [-1, 7, 8], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 2 tiles down 1 tile right, jump over other pieces, and takes opponents piece" do
      (3..8).each do |n|
        ("a".."g").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next}#{n - 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -15)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -15, n, l, [1, -7, -8], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile down 2 tiles right, jump over other pieces, and takes opponents piece" do
      (2..8).each do |n|
        ("a".."f").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next.next}#{n - 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -6)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -6, n, l, [1, -7, -8], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 2 tiles down 1 tile left, jump over other pieces, and takes opponents piece" do
      (3..8).each do |n|
        ("b".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 1).chr}#{n - 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -17)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -17, n, l, [-1, -8, -9], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile down 2 tiles left, jump over other pieces, and takes opponents piece" do
      (2..8).each do |n|
        ("c".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 2).chr}#{n - 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -10)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -10, n, l, [-1, -8, -9], "\u2658".encode('utf-8'))
            expect {move_knight.compute}.to change {move_knight.board.board[tile_num[:start]]}.and change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 2 tiles up 1 tile right, jump over other pieces, and fails to take square of own piece" do
      (1..6).each do |n|
        ("a".."g").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next}#{n + 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 17)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 17, n, l, [1, 8, 9], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile up 2 tiles right, jump over other pieces, and fails to take square of own piece" do
      (1..7).each do |n|
        ("a".."f").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next.next}#{n + 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 10)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 10, n, l, [1, 8, 9], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 2 tiles up 1 tile left, jump over other pieces, and fails to take square of own piece" do
      (1..6).each do |n|
        ("b".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 1).chr}#{n + 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 15)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 15, n, l, [-1, 7, 8], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile up 2 tiles left, jump over other pieces, and fails to take square of own piece" do
      (1..7).each do |n|
        ("c".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 2).chr}#{n + 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, 6)
            generate_test_pieces(tile_num[:start], tile_num[:finish], 6, n, l, [-1, 7, 8], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 2 tiles down 1 tile right, jump over other pieces, and fails to take square of own piece" do
      (3..8).each do |n|
        ("a".."g").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next}#{n - 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -15)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -15, n, l, [1, -7, -8], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile down 2 tiles right, jump over other pieces, and fails to take square of own piece" do
      (2..8).each do |n|
        ("a".."f").each do |l|
          it "moves a knight from #{l}#{n} to #{l.next.next}#{n - 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -6)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -6, n, l, [1, -7, -8], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 2 tiles down 1 tile left, jump over other pieces, and fails to take square of own piece" do
      (3..8).each do |n|
        ("b".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 1).chr}#{n - 2}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -17)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -17, n, l, [-1, -8, -9], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end

    context "move knight 1 tile down 2 tiles left, jump over other pieces, and fails to take square of own piece" do
      (2..8).each do |n|
        ("c".."h").each do |l|
          it "moves a knight from #{l}#{n} to #{(l.ord - 2).chr}#{n - 1}" do
            tile_num = generate_start_and_finish_tile_num(n, l, -10)
            generate_test_pieces(tile_num[:start], tile_num[:finish], -10, n, l, [-1, -8, -9], "\u265E".encode('utf-8'))
            expect {move_knight.compute}.to_not change {move_knight.board.board[tile_num[:finish]]}
          end
        end
      end
    end
  end
end