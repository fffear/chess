$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"

require 'move_king'
require 'play_game'
require 'chess_pieces'
require 'coordinates'

describe MoveKing do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:move_white_king) {MoveKing.new(0, 0, chess.board, ChessPieces::WHITE_PIECES)}
  let(:move_black_king) {MoveKing.new(0, 0, chess.board, ChessPieces::BLACK_PIECES)}

  def generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    start = convert_coordinates_to_num(generate_coordinates(n, l))
    finish = convert_coordinates_to_num(generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr))
    {start: start, finish: finish}
  end

  def generate_blocking_piece(tile_num, shift_factor, knight_piece)
    chess.board.board[tile_num + shift_factor].piece = Knight.new(knight_piece)
  end

  def set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, king_piece)
    if king_piece == "\u2654".encode('utf-8')
      move_white_king.origin = generate_coordinates(n, l)
      move_white_king.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    else
      move_black_king.origin = generate_coordinates(n, l)
      move_black_king.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    end
  end

  def input_king(tile_num, king_piece)
    chess.board.board[tile_num].piece = King.new(king_piece)
  end

  def test_without_blocking_pieces(n, l, shift_factor_n, shift_factor_l, king_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_king(tile_num[:start], king_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, king_piece)
    chess.board.print_board
    yield(tile_num[:start], tile_num[:finish], king_piece)
    chess.board.print_board
  end

  def test_with_blocking_pieces(n, l, shift_factor_n, shift_factor_l, shift_blocking_piece, king_piece, knight_piece, &block)
    RSpec::Matchers.define_negated_matcher :not_change, :change
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_king(tile_num[:start], king_piece)
    generate_blocking_piece(tile_num[:finish], shift_blocking_piece, knight_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, king_piece)
    chess.board.print_board
    yield(tile_num[:start], tile_num[:finish], king_piece)
    chess.board.print_board
  end

  def change_in_origin_and_destination
    lambda do |origin, destination, king_piece|
      if king_piece == "\u2654".encode('utf-8')
        expect {move_white_king.compute}.to change {move_white_king.board.board[origin]}.and change {move_white_king.board.board[destination]}
      else
        expect {move_black_king.compute}.to change {move_black_king.board.board[origin]}.and change {move_black_king.board.board[destination]}
      end
    end
  end

  def no_change_in_origin_and_destination
    lambda do |origin, destination, king_piece|
      if king_piece == "\u2654".encode('utf-8')
        expect {move_white_king.compute}.to not_change {move_white_king.board.board[origin]}.and not_change {move_white_king.board.board[destination]}.and output.to_stdout
      else
        expect {move_black_king.compute}.to not_change {move_black_king.board.board[origin]}.and not_change {move_black_king.board.board[destination]}.and output.to_stdout
      end 
    end
  end

  describe "#compute" do
    letters = ("a".."h").to_a
    numbers = (1..8).to_a
    shift_factor = (1..7).to_a

    context "move 1 tile without any blocking pieces" do
      ["\u2654".encode('utf-8'), "\u265A".encode('utf-8')].each_with_index do |king, idx|
        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces upwards" do
          letters.each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "move from #{l}#{n} to #{l}#{n + 1}" do
                test_without_blocking_pieces(n, l, 1, 0, king, &change_in_origin_and_destination)
              end
            end
          end
        end

        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces downwards" do
        #  letters.each do |l|
        #    numbers[1..numbers.length - 1].each do |n|
        #      it "move from #{l}#{n} to #{l}#{n - 1}" do
        #        test_without_blocking_pieces(n, l, -1, 0, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end
#
        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces right" do
        #  letters[0..letters.length - 2].each do |l|
        #    numbers.each do |n|
        #      it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n}" do
        #        test_without_blocking_pieces(n, l, 0, 1, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end
        #
        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces left" do
        #  letters[1..letters.length - 1].each do |l|
        #    numbers.each do |n|
        #      it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n}" do
        #        test_without_blocking_pieces(n, l, 0, -1, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end
#
        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up right" do
        #  letters[0..letters.length - 2].each do |l|
        #    numbers[0..letters.length - 2].each do |n|
        #      it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
        #        test_without_blocking_pieces(n, l, 1, 1, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end
#
        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up left" do
        #  letters[1..letters.length - 1].each do |l|
        #    numbers[0..letters.length - 2].each do |n|
        #      it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
        #        test_without_blocking_pieces(n, l, 1, -1, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end
#
        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down right" do
        #  letters[0..letters.length - 2].each do |l|
        #    numbers[1..letters.length - 1].each do |n|
        #      it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
        #        test_without_blocking_pieces(n, l, -1, 1, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end
#
        #context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down left" do
        #  letters[1..letters.length - 1].each do |l|
        #    numbers[1..letters.length - 1].each do |n|
        #      it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
        #        test_without_blocking_pieces(n, l, -1, -1, king, &change_in_origin_and_destination)
        #      end
        #    end
        #  end
        #end 
      end
    end

    context "fails to move 1 tile with a blocking friendly piece on the destination" do
      ["\u2654".encode('utf-8'), "\u265A".encode('utf-8')].each_with_index do |king, idx|
        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces upwards" do
          letters.each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "fail to move king from #{l}#{n} to #{l}#{n + 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 1, 0, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 1, 0, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces downwards" do
          letters.each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "fail to move king from #{l}#{n} to #{l}#{n - 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -1, 0, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -1, 0, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces right" do
          letters[0..letters.length - 2].each do |l|
            numbers.each do |n|
              it "fail to move king from #{l}#{n} to #{(l.ord + 1).chr}#{n}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 0, 1, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 0, 1, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces left" do
          letters[1..letters.length - 1].each do |l|
            numbers.each do |n|
              it "fail to move king from #{l}#{n} to #{(l.ord - 1).chr}#{n}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 0, -1, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 0, -1, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up right" do
          letters[0..letters.length - 2].each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "fail to move king from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 1, 1, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 1, 1, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up left" do
          letters[1..letters.length - 1].each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "fail to move king from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 1, -1, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 1, -1, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down right" do
          letters[0..letters.length - 2].each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "fail to move king from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -1, 1, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -1, 1, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fails to move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down left" do
          letters[1..letters.length - 1].each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "fail to move king from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -1, -1, 0, king, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -1, -1, 0, king, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end

    context "move 1 tile with an opponents piece on the destination" do
      ["\u2654".encode('utf-8'), "\u265A".encode('utf-8')].each_with_index do |king, idx|
        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces upwards" do
          letters.each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "move king from #{l}#{n} to #{l}#{n + 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 1, 0, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 1, 0, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces downwards" do
          letters.each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "move king from #{l}#{n} to #{l}#{n - 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -1, 0, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -1, 0, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces right" do
          letters[0..letters.length - 2].each do |l|
            numbers.each do |n|
              it "move king from #{l}#{n} to #{(l.ord + 1).chr}#{n}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 0, 1, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 0, 1, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces left" do
          letters[1..letters.length - 1].each do |l|
            numbers.each do |n|
              it "move king from #{l}#{n} to #{(l.ord - 1).chr}#{n}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 0, -1, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 0, -1, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up right" do
          letters[0..letters.length - 2].each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "move king from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 1, 1, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 1, 1, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up left" do
          letters[1..letters.length - 1].each do |l|
            numbers[0..numbers.length - 2].each do |n|
              it "move king from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, 1, -1, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, 1, -1, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down right" do
          letters[0..letters.length - 2].each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "move king from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -1, 1, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -1, 1, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "move #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down left" do
          letters[1..letters.length - 1].each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "move king from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -1, -1, 0, king, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -1, -1, 0, king, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end
  end
end