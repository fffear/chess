$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"

require 'move_pawn'
require 'play_game'
require 'chess_pieces'
require 'coordinates'

describe MovePawn do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:move_white_pawn) {MovePawn.new(0, 0, chess.board, ChessPieces::WHITE_PIECES)}
  let(:move_black_pawn) {MovePawn.new(0, 0, chess.board, ChessPieces::BLACK_PIECES)}
  RSpec::Matchers.define_negated_matcher :not_change, :change

  def generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    start = convert_coordinates_to_num(generate_coordinates(n, l))
    finish = convert_coordinates_to_num(generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr))
    {start: start, finish: finish}
  end

  def generate_blocking_piece(tile_num, shift_factor, knight_piece)
    chess.board.board[tile_num + shift_factor].piece = Knight.new(knight_piece)
  end

  def set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, pawn_piece)
    if pawn_piece == "\u2659".encode('utf-8')
      move_white_pawn.origin = generate_coordinates(n, l)
      move_white_pawn.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    else
      move_black_pawn.origin = generate_coordinates(n, l)
      move_black_pawn.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    end
  end

  def input_king(tile_num, pawn_piece)
    chess.board.board[tile_num].piece = Pawn.new(pawn_piece)
  end

  def test_without_blocking_pieces(n, l, shift_factor_n, shift_factor_l, pawn_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_king(tile_num[:start], pawn_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, pawn_piece)
    yield(tile_num[:start], tile_num[:finish], pawn_piece)
  end

  def test_with_blocking_pieces(n, l, shift_factor_n, shift_factor_l, shift_blocking_piece, pawn_piece, knight_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_king(tile_num[:start], pawn_piece)
    generate_blocking_piece(tile_num[:finish], shift_blocking_piece, knight_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, pawn_piece)
    yield(tile_num[:start], tile_num[:finish], pawn_piece)
  end

  def change_in_origin_and_destination
    lambda do |origin, destination, pawn_piece|
      if pawn_piece == "\u2659".encode('utf-8')
        expect {move_white_pawn.compute}.to change {move_white_pawn.board.board[origin]}.and change {move_white_pawn.board.board[destination]}
      else
        expect {move_black_pawn.compute}.to change {move_black_pawn.board.board[origin]}.and change {move_black_pawn.board.board[destination]}
      end
    end
  end

  def no_change_in_origin_and_destination
    lambda do |origin, destination, pawn_piece|
      if pawn_piece == "\u2659".encode('utf-8')
        expect {move_white_pawn.compute}.to not_change {move_white_pawn.board.board[origin]}.and not_change {move_white_pawn.board.board[destination]}.and output.to_stdout
      else
        expect {move_black_pawn.compute}.to not_change {move_black_pawn.board.board[origin]}.and not_change {move_black_pawn.board.board[destination]}.and output.to_stdout
      end 
    end
  end

  describe "#compute" do
    letters = ("a".."h").to_a
    numbers = (1..8).to_a
    shift_factor = (1..7).to_a

    context "move 1 tile without any blocking pieces" do
      context "moves white pawn 1 spaces upwards" do
        letters.each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "move from #{l}#{n} to #{l}#{n + 1}" do
              test_without_blocking_pieces(n, l, 1, 0, "\u2659".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end

      context "moves black pawn 1 spaces downwards" do
        letters.each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "move from #{l}#{n} to #{l}#{n - 1}" do
              test_without_blocking_pieces(n, l, -1, 0, "\u265F".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end
    end

    context "move 2 tiles without any blocking pieces" do
      context "moves white pawn 2 spaces upwards from starting position" do
        letters.each do |l|
          numbers[1..1].each do |n|
            it "move from #{l}#{n} to #{l}#{n + 2}" do
              test_without_blocking_pieces(n, l, 2, 0, "\u2659".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end

      context "moves black pawn 2 spaces upwards from starting position" do
        letters.each do |l|
          numbers[6..6].each do |n|
            it "move from #{l}#{n} to #{l}#{n - 2}" do
              test_without_blocking_pieces(n, l, -2, 0, "\u265F".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end
    end

    context "fail to move without any blocking pieces" do
      context "fail to move white pawn 2 spaces upwards from positions which are not the starting position" do
        letters.each do |l|
          numbers[2..numbers.length - 3].each do |n|
            it "fail to move from #{l}#{n} to #{l}#{n + 2}" do
              test_without_blocking_pieces(n, l, 2, 0, "\u2659".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 2 spaces downwards from positions which are not the starting position" do
        letters.each do |l|
          numbers[2..numbers.length - 3].each do |n|
            it "fail to move from #{l}#{n} to #{l}#{n - 2}" do
              test_without_blocking_pieces(n, l, -2, 0, "\u265F".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move white pawn 1 space diagonally up right when the space is empty" do
        letters[0..letters.length - 2].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
              test_without_blocking_pieces(n, l, 1, 1, "\u2659".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move white pawn 1 space diagonally up left when the space is empty" do
        letters[1..letters.length - 1].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
              test_without_blocking_pieces(n, l, 1, -1, "\u2659".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 1 space diagonally down right when the space is empty" do
        letters[0..letters.length - 2].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
              test_without_blocking_pieces(n, l, -1, 1, "\u265F".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 1 space diagonally down left when the space is empty" do
        letters[1..letters.length - 1].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
              test_without_blocking_pieces(n, l, -1, -1, "\u265F".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end
    end

    context "fail to move vertically with blocking piece on the destination file" do
      context "fail to move white pawn 2 spaces upwards with a friendly blocking piece" do
        letters.each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{l}#{n + 1}" do
              test_with_blocking_pieces(n, l, 1, 0, 0, "\u2659".encode('utf-8'), "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 2 spaces downwards with a friendly blocking piece" do
        letters.each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{l}#{n - 1}" do
              test_with_blocking_pieces(n, l, -1, 0, 0, "\u265F".encode('utf-8'), "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move white pawn 2 spaces upwards with a opponent blocking piece" do
        letters.each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{l}#{n + 1}" do
              test_with_blocking_pieces(n, l, 1, 0, 0, "\u2659".encode('utf-8'), "\u265C".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 2 spaces downwards with an opponent blocking piece" do
        letters.each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{l}#{n - 1}" do
              test_with_blocking_pieces(n, l, -1, 0, 0, "\u265F".encode('utf-8'), "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end
    end

    context "fail to move diagonally with blocking piece on the destination file" do
      context "fail to move white pawn 1 space diagonally up right with a friendly blocking piece" do
        letters[0..letters.length - 2].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
              test_with_blocking_pieces(n, l, 1, 1, 0, "\u2659".encode('utf-8'), "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move white pawn 1 space diagonally up left with a friendly blocking piece" do
        letters[1..letters.length - 1].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
              test_with_blocking_pieces(n, l, 1, -1, 0, "\u2659".encode('utf-8'), "\u2656".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 1 space diagonally down right with a friendly blocking piece" do
        letters[0..letters.length - 2].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
              test_with_blocking_pieces(n, l, -1, 1, 0, "\u265F".encode('utf-8'), "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end

      context "fail to move black pawn 1 space diagonally down left with a friendly blocking piece" do
        letters[1..letters.length - 1].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "fail to move from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
              test_with_blocking_pieces(n, l, -1, -1, 0, "\u265F".encode('utf-8'), "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
            end
          end
        end
      end
    end

    context "move diagonally with opponent piece on the destination file" do
      context "move white pawn 1 space diagonally up right" do
        letters[0..letters.length - 2].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
              test_with_blocking_pieces(n, l, 1, 1, 0, "\u2659".encode('utf-8'), "\u265C".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end

      context "move white pawn 1 space diagonally up left" do
        letters[1..letters.length - 1].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
              test_with_blocking_pieces(n, l, 1, -1, 0, "\u2659".encode('utf-8'), "\u265C".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end

      context "move black pawn 1 space diagonally down right" do
        letters[0..letters.length - 2].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
              test_with_blocking_pieces(n, l, -1, 1, 0, "\u265F".encode('utf-8'), "\u2656".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end

      context "move black pawn 1 space diagonally down left" do
        letters[1..letters.length - 1].each do |l|
          numbers[1..numbers.length - 2].each do |n|
            it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
              test_with_blocking_pieces(n, l, -1, -1, 0, "\u265F".encode('utf-8'), "\u2656".encode('utf-8'), &change_in_origin_and_destination)
            end
          end
        end
      end
    end
  end
end