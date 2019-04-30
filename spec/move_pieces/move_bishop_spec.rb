$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"

require 'move_bishop'
require 'play_game'
require 'chess_pieces'
require 'coordinates'

describe MoveBishop do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:move_white_bishop) {MoveBishop.new(0, 0, chess.board, ChessPieces::WHITE_PIECES)}
  let(:move_black_bishop) {MoveBishop.new(0, 0, chess.board, ChessPieces::BLACK_PIECES)}

  def generate_blocking_piece(tile_num, shift_factor, rook_piece)
    chess.board.board[tile_num + shift_factor].piece = Rook.new(rook_piece)
  end

  def generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    start = convert_coordinates_to_num(generate_coordinates(n, l))
    finish = convert_coordinates_to_num(generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr))
    {start: start, finish: finish}
  end

  def set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, bishop_color)
    if bishop_color == "\u2657".encode('utf-8')
      move_white_bishop.origin = generate_coordinates(n, l)
      move_white_bishop.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    else
      move_black_bishop.origin = generate_coordinates(n, l)
      move_black_bishop.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    end
  end

  def input_bishop(tile_num, bishop_piece)
    chess.board.board[tile_num].piece = Bishop.new(bishop_piece)
  end

  def test_without_blocking_pieces(n, l, shift_factor_n, shift_factor_l, bishop_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_bishop(tile_num[:start], bishop_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, bishop_piece)
    yield(tile_num[:start], tile_num[:finish], bishop_piece)
  end

  def change_in_origin_and_destination
    lambda do |origin, destination, bishop_piece|
      if bishop_piece == "\u2657".encode('utf-8')
        expect {move_white_bishop.compute}.to change {move_white_bishop.board.board[origin]}.and change {move_white_bishop.board.board[destination]}
      else
        expect {move_black_bishop.compute}.to change {move_black_bishop.board.board[origin]}.and change {move_black_bishop.board.board[destination]}
      end
    end
  end

  def no_change_in_origin_and_destination
    lambda do |origin, destination, bishop_piece|
      if bishop_piece == "\u2657".encode('utf-8')
        expect {move_white_bishop.compute}.to not_change {move_white_bishop.board.board[origin]}.and not_change {move_white_bishop.board.board[destination]}.and output.to_stdout
      else
        expect {move_black_bishop.compute}.to not_change {move_black_bishop.board.board[origin]}.and not_change {move_black_bishop.board.board[destination]}.and output.to_stdout
      end 
    end
  end

  def test_with_blocking_pieces(n, l, shift_factor_n, shift_factor_l, shift_blocking_piece, bishop_piece, rook_piece, &block)
    RSpec::Matchers.define_negated_matcher :not_change, :change
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_bishop(tile_num[:start], bishop_piece)
    generate_blocking_piece(tile_num[:finish], shift_blocking_piece, rook_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, bishop_piece)
    yield(tile_num[:start], tile_num[:finish], bishop_piece)
  end

  describe "#compute" do
    letters = ("a".."h").to_a
    numbers = (1..8).to_a
    shift_factor = (1..7).to_a

    ["\u265D".encode('utf-8'), "\u2657".encode('utf-8')].each_with_index do |bishop_color, idx|
      shift_factor.each do |num|
        context "move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up right" do
          letters[0..letters.length - (num + 1)].each do |l|
            numbers[0..numbers.length - (num + 1)].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n + num}" do
                test_without_blocking_pieces(n, l, num, num, bishop_color, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up left" do
          letters[num..letters.length - 1].each do |l|
            numbers[0..numbers.length - (num + 1)].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n + num}" do
                test_without_blocking_pieces(n, l, num, -num, bishop_color, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down right" do
          letters[0..letters.length - (num + 1)].each do |l|
            numbers[num..numbers.length - 1].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n - num}" do
                test_without_blocking_pieces(n, l, -num, num, bishop_color, &change_in_origin_and_destination)
              end
            end
          end
        end  

        context "move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down left" do
          letters[num..letters.length - 1].each do |l|
            numbers[num..numbers.length - 1].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n - num}" do
                test_without_blocking_pieces(n, l, -num, -num, bishop_color, &change_in_origin_and_destination)
              end
            end
          end
        end
      end
    end

    ["\u265D".encode('utf-8'), "\u2657".encode('utf-8')].each_with_index do |bishop_color, idx|
      shift_factor.each do |num|
        context "fail to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up right with a friendly piece located on the destination tile" do
          letters[0..letters.length - (num + 1)].each do |l|
            numbers[0..numbers.length - (num + 1)].each do |n|
              it " fail to move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n + num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, num, num, 0, bishop_color, "\u265C".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, num, num, 0, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fail to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up left with a friendly piece located on the destination tile" do
          letters[num..letters.length - 1].each do |l|
            numbers[0..numbers.length - (num + 1)].each do |n|
              it "fail to move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n + num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, num, -num, 0, bishop_color, "\u265C".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, num, -num, 0, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "fail to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down right with a friendly piece located on the destination tile" do
          letters[0..letters.length - (num + 1)].each do |l|
            numbers[num..numbers.length - 1].each do |n|
              it "fail to move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n - num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -num, num, 0, bishop_color, "\u265C".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -num, num, 0, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end 

        context "fail to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down left with a friendly piece located on the destination tile" do
          letters[num..letters.length - 1].each do |l|
            numbers[num..numbers.length - 1].each do |n|
              it "fail to move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n - num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -num, -num, 0, bishop_color, "\u265C".encode('utf-8'), &no_change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -num, -num, 0, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end

    ["\u265D".encode('utf-8'), "\u2657".encode('utf-8')].each_with_index do |bishop_color, idx|
      shift_factor.each do |num|
        context "moves #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up right with an opponent's piece located on the destination tile" do
          letters[0..letters.length - (num + 1)].each do |l|
            numbers[0..numbers.length - (num + 1)].each do |n|
              it " move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n + num}" do
               if idx.zero?
                 test_with_blocking_pieces(n, l, num, num, 0, bishop_color, "\u2656".encode('utf-8'), &change_in_origin_and_destination)
               else
                 test_with_blocking_pieces(n, l, num, num, 0, bishop_color, "\u265C".encode('utf-8'), &change_in_origin_and_destination)
               end
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up left with an opponent's piece located on the destination tile" do
          letters[num..letters.length - 1].each do |l|
            numbers[0..numbers.length - (num + 1)].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n + num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, num, -num, 0, bishop_color, "\u2656".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, num, -num, 0, bishop_color, "\u265C".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down right with an opponent's piece located on the destination tile" do
          letters[0..letters.length - (num + 1)].each do |l|
            numbers[num..numbers.length - 1].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n - num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -num, num, 0, bishop_color, "\u2656".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -num, num, 0, bishop_color, "\u265C".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end 

        context "moves #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down left with an opponent's piece located on the destination tile" do
          letters[num..letters.length - 1].each do |l|
            numbers[num..numbers.length - 1].each do |n|
              it "move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n - num}" do
                if idx.zero?
                  test_with_blocking_pieces(n, l, -num, -num, 0, bishop_color, "\u2656".encode('utf-8'), &change_in_origin_and_destination)
                else
                  test_with_blocking_pieces(n, l, -num, -num, 0, bishop_color, "\u265C".encode('utf-8'), &change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end
    
    ["\u265D".encode('utf-8'), "\u2657".encode('utf-8')].each_with_index do |bishop_color, idx|
      (1..6).to_a.each do |block_piece_n|
        shift_factor[block_piece_n..6].each do |num|      
          context "fails to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up right #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters[0..letters.length - (num + 1)].each do |l|
              numbers[0..numbers.length - (num + 1)].each do |n|
                it " fail to move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n + num}" do
                  test_with_blocking_pieces(n, l, num, num, block_piece_n * -9, bishop_color, "\u265C".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end

          context "fails to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally up left #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters[num..letters.length - 1].each do |l|
              numbers[0..numbers.length - (num + 1)].each do |n|
                it "fail to move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n + num}" do
                  test_with_blocking_pieces(n, l, num, -num, block_piece_n *-7, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down right #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters[0..letters.length - (num + 1)].each do |l|
              numbers[num..numbers.length - 1].each do |n|
                it "fail to move a bishop from #{l}#{n} to #{(l.ord + num).chr}#{n - num}" do
                  test_with_blocking_pieces(n, l, -num, num, block_piece_n * 7, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? "black bishop" : "white bishop"} #{num} spaces diagonally down left #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters[num..letters.length - 1].each do |l|
              numbers[num..numbers.length - 1].each do |n|
                it "fail to move a bishop from #{l}#{n} to #{(l.ord - num).chr}#{n - num}" do
                  test_with_blocking_pieces(n, l, -num, -num, block_piece_n * 9, bishop_color, "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end
  end
end
