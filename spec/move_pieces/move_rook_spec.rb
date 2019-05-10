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
  let(:move_white_rook) {MoveRook.new(0, 0, chess.board, ChessPieces::WHITE_PIECES)}
  let(:move_black_rook) {MoveRook.new(0, 0, chess.board, ChessPieces::BLACK_PIECES)}

  def generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    start = convert_coordinates_to_num(generate_coordinates(n, l))
    finish = convert_coordinates_to_num(generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr))
    {start: start, finish: finish}
  end

  def generate_blocking_piece(tile_num, shift_factor, knight_piece)
    chess.board.board[tile_num + shift_factor].piece = Knight.new(knight_piece)
  end

  def set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, rook_piece)
    if rook_piece == "\u2656".encode('utf-8')
      move_white_rook.origin = generate_coordinates(n, l)
      move_white_rook.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    else
      move_black_rook.origin = generate_coordinates(n, l)
      move_black_rook.destination = generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr)
    end
  end

  def input_rook(tile_num, rook_piece)
    chess.board.board[tile_num].piece = Rook.new(rook_piece)
  end

  def test_without_blocking_pieces(n, l, shift_factor_n, shift_factor_l, rook_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_rook(tile_num[:start], rook_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, rook_piece)
    yield(tile_num[:start], tile_num[:finish], rook_piece)
  end

  def test_with_blocking_pieces(n, l, shift_factor_n, shift_factor_l, shift_blocking_piece, rook_piece, knight_piece, &block)
    RSpec::Matchers.define_negated_matcher :not_change, :change
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_rook(tile_num[:start], rook_piece)
    generate_blocking_piece(tile_num[:finish], shift_blocking_piece, knight_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, rook_piece)
    yield(tile_num[:start], tile_num[:finish], rook_piece)
  end

  def change_in_origin_and_destination
    lambda do |origin, destination, rook_piece|
      if rook_piece == "\u2656".encode('utf-8')
        expect {move_white_rook.compute}.to change {move_white_rook.board.board[origin]}.and change {move_white_rook.board.board[destination]}
      else
        expect {move_black_rook.compute}.to change {move_black_rook.board.board[origin]}.and change {move_black_rook.board.board[destination]}
      end
    end
  end

  def no_change_in_origin_and_destination
    lambda do |origin, destination, rook_piece|
      if rook_piece == "\u2656".encode('utf-8')
        expect {move_white_rook.compute}.to not_change {move_white_rook.board.board[origin]}.and not_change {move_white_rook.board.board[destination]}.and output.to_stdout
      else
        expect {move_black_rook.compute}.to not_change {move_black_rook.board.board[origin]}.and not_change {move_black_rook.board.board[destination]}.and output.to_stdout
      end 
    end
  end

  describe "#compute" do
    letters = ("a".."h").to_a
    numbers = (1..8).to_a
    shift_factor = (1..7).to_a

    context "move vertically and horizontally with no blocking pieces" do
      ["\u2656".encode('utf-8'), "\u265C".encode('utf-8')].each_with_index do |rook, idx|
        shift_factor.each do |num|
          context "moves #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces upwards" do
            letters.each do |l|
              numbers[0..numbers.length - (num + 1)].each do |n|
                it "move from #{l}#{n} to #{l}#{n + num}" do
                  test_without_blocking_pieces(n, l, num, 0, rook, &change_in_origin_and_destination)
                end
              end
            end
          end

          context "moves #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces downwards" do
            letters.each do |l|
              numbers[num..numbers.length - 1].each do |n|
                it "move from #{l}#{n} to #{l}#{n - num}" do
                  test_without_blocking_pieces(n, l, -num, 0, rook, &change_in_origin_and_destination)
                end
              end
            end
          end

          context "moves #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces right" do
            letters[0..letters.length - (num + 1)].each do |l|
              numbers.each do |n|
                it "move from #{l}#{n} to #{(l.ord + num).chr}#{n}" do
                  test_without_blocking_pieces(n, l, 0, num, rook, &change_in_origin_and_destination)
                end
              end
            end
          end

          context "moves #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces left" do
            letters[num..letters.length - 1].each do |l|
              numbers.each do |n|
                it "move from #{l}#{n} to #{(l.ord - num).chr}#{n}" do
                  test_without_blocking_pieces(n, l, 0, -num, rook, &change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end

    context "fail to move vertically and horizontally with friendly piece on destination tile" do
      ["\u2656".encode('utf-8'), "\u265C".encode('utf-8')].each_with_index do |rook, idx|
        shift_factor.each do |num|
          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces upwards" do
            letters.each do |l|
              numbers[0..numbers.length - (num + 1)].each do |n|
                it "fail to move from #{l}#{n} to #{l}#{n + num}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, num, 0, 0, rook, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, num, 0, 0, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                  end
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces downwards" do
            letters.each do |l|
              numbers[num..numbers.length - 1].each do |n|
                it "fail to move from #{l}#{n} to #{l}#{n - num}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, -num, 0, 0, rook, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, -num, 0, 0, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                  end
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces right" do
            letters[0..letters.length - (num + 1)].each do |l|
              numbers.each do |n|
                it "fail to move from #{l}#{n} to #{(l.ord + num).chr}#{n}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, 0, num, 0, rook, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, 0, num, 0, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                  end
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces left" do
            letters[num..letters.length - 1].each do |l|
              numbers.each do |n|
                it "fail to move from #{l}#{n} to #{(l.ord - num).chr}#{n}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, 0, -num, 0, rook, "\u2658".encode('utf-8'), &no_change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, 0, -num, 0, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                  end
                end
              end
            end
          end
        end
      end
    end

    context "move vertically and horizontally with an opponent piece on destination tile" do
      ["\u2656".encode('utf-8'), "\u265C".encode('utf-8')].each_with_index do |rook, idx|
        shift_factor.each do |num|
          context "move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces upwards" do
            letters.each do |l|
              numbers[0..numbers.length - (num + 1)].each do |n|
                it "move from #{l}#{n} to #{l}#{n + num}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, num, 0, 0, rook, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, num, 0, 0, rook, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                  end
                end
              end
            end
          end

          context "move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces downwards" do
            letters.each do |l|
              numbers[num..numbers.length - 1].each do |n|
                it "move from #{l}#{n} to #{l}#{n - num}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, -num, 0, 0, rook, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, -num, 0, 0, rook, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                  end
                end
              end
            end
          end

          context "move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces right" do
            letters[0..letters.length - (num + 1)].each do |l|
              numbers.each do |n|
                it "move from #{l}#{n} to #{(l.ord + num).chr}#{n}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, 0, num, 0, rook, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, 0, num, 0, rook, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                  end
                end
              end
            end
          end

          context "move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces left" do
            letters[num..letters.length - 1].each do |l|
              numbers.each do |n|
                it "move from #{l}#{n} to #{(l.ord - num).chr}#{n}" do
                  if idx.zero?
                    test_with_blocking_pieces(n, l, 0, -num, 0, rook, "\u265E".encode('utf-8'), &change_in_origin_and_destination)
                  else
                    test_with_blocking_pieces(n, l, 0, -num, 0, rook, "\u2658".encode('utf-8'), &change_in_origin_and_destination)
                  end
                end
              end
            end
          end
        end
      end
    end

    ["\u2656".encode('utf-8'), "\u265C".encode('utf-8')].each_with_index do |rook, idx|
      (1..7).to_a.each do |block_piece_n|
        shift_factor[block_piece_n..6].each do |num|      
          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces upwards #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters.each do |l|
              numbers[0..numbers.length - (num + 1)].each do |n|
                it "fail to move from #{l}#{n} to #{l}#{n + num}" do
                  test_with_blocking_pieces(n, l, num, 0, -8 * block_piece_n, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces downwards #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters.each do |l|
              numbers[num..numbers.length - 1].each do |n|
                it "fail to move from #{l}#{n} to #{l}#{n - num}" do
                  test_with_blocking_pieces(n, l, -num, 0, 8 * block_piece_n, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces right #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters[0..letters.length - (num + 1)].each do |l|
              numbers.each do |n|
                it "fail to move from #{l}#{n} to #{(l.ord + num).chr}#{n}" do
                  test_with_blocking_pieces(n, l, 0, num, -block_piece_n, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end

          context "fail to move #{(idx.zero?) ? 'white rook' : 'black rook'} #{num} spaces left #{block_piece_n} spaces beyond a piece blocking the path of the destination tile" do
            letters[num..letters.length - 1].each do |l|
              numbers.each do |n|
                it "fail to move from #{l}#{n} to #{(l.ord - num).chr}#{n}" do
                  test_with_blocking_pieces(n, l, 0, -num, block_piece_n, rook, "\u265E".encode('utf-8'), &no_change_in_origin_and_destination)
                end
              end
            end
          end
        end
      end
    end
  end

 

end