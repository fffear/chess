$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/modules', __FILE__)}"

require 'move_king'
require 'chess'
require 'chess_pieces'
require 'coordinates'
require 'possible_moves'

describe MoveKing do
  include Coordinates
  include ChessPieces
  include PossibleMoves
  let(:chess) { Chess.new }
  let(:move_white_king) {MoveKing.new(0, 0, chess.board, ChessPieces::WHITE_PIECES, 0)}
  let(:move_black_king) {MoveKing.new(0, 0, chess.board, ChessPieces::BLACK_PIECES, 0)}
  RSpec::Matchers.define_negated_matcher :not_change, :change

  def generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    start = convert_coordinates_to_num(generate_coordinates(n, l))
    finish = convert_coordinates_to_num(generate_coordinates(n + shift_factor_n, (l.ord + shift_factor_l).chr))
    {start: start, finish: finish}
  end

  def generate_rook_piece(rook_space, rook_piece)
    chess.board.board[rook_space].piece = Rook.new(rook_piece)
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

  def input_rook(tile_num, rook_piece)
    chess.board.board[tile_num].piece = Rook.new(rook_piece)
  end

  def input_knight(tile_num, knight_piece)
    chess.board.board[tile_num].piece = Knight.new(knight_piece)
  end

  def input_queen(tile_num, queen_piece)
    chess.board.board[tile_num].piece = Queen.new(queen_piece)
  end

  def input_pawn(tile_num, pawn_piece)
    chess.board.board[tile_num].piece = Pawn.new(pawn_piece, 8)
  end

  def input_bishop(tile_num, bishop_piece)
    chess.board.board[tile_num].piece = Bishop.new(bishop_piece)
  end

  def test_without_blocking_pieces(n, l, shift_factor_n, shift_factor_l, king_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_king(tile_num[:start], king_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, king_piece)
    yield(tile_num[:start], tile_num[:finish], king_piece)
  end

  def test_with_blocking_pieces(n, l, shift_factor_n, shift_factor_l, shift_blocking_piece, king_piece, knight_piece, &block)
    tile_num = generate_start_and_finish_tile_num(n, l, shift_factor_n, shift_factor_l)
    input_king(tile_num[:start], king_piece)
    generate_blocking_piece(tile_num[:finish], shift_blocking_piece, knight_piece)
    set_origin_and_destination_coordinates(n, l, shift_factor_n, shift_factor_l, king_piece)
    yield(tile_num[:start], tile_num[:finish], king_piece)
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

  def test_castling(color_of_pieces, starting_num, rook_num, shift_factor_l)
    tile_num = generate_start_and_finish_tile_num(starting_num, "e", 0, shift_factor_l)
    input_king(tile_num[:start], color_of_pieces[4])
    generate_rook_piece(rook_num, color_of_pieces[0])
    set_origin_and_destination_coordinates(starting_num, "e", 0, shift_factor_l, color_of_pieces[4])
    if color_of_pieces == ChessPieces::WHITE_PIECES
      expect {move_white_king.compute}.to change {move_white_king.board.board[rook_num]}.and change {move_white_king.board.board[tile_num[:start]]}
    else
      expect {move_black_king.compute}.to change {move_black_king.board.board[rook_num]}.and change {move_black_king.board.board[tile_num[:start]]}
    end
  end

  def test_castling_threatening_pieces(color_of_pieces, starting_num, rook_num, shift_factor_l)
    tile_num = generate_start_and_finish_tile_num(starting_num, "e", 0, shift_factor_l)
    input_king(tile_num[:start], color_of_pieces[4])
    generate_rook_piece(rook_num, color_of_pieces[0])
    set_origin_and_destination_coordinates(starting_num, "e", 0, shift_factor_l, color_of_pieces[4])
    if color_of_pieces == ChessPieces::WHITE_PIECES
      expect {move_white_king.compute}.to not_change {move_white_king.board.board[rook_num]}.and not_change {move_white_king.board.board[tile_num[:start]]}.and output.to_stdout
    else
      expect {move_black_king.compute}.to not_change {move_black_king.board.board[rook_num]}.and not_change {move_black_king.board.board[tile_num[:start]]}.and output.to_stdout
    end
  end

  describe "#compute" do
    letters = ("a".."h").to_a
    numbers = (1..8).to_a
    shift_factor = (1..7).to_a

    context "castling" do
      context "castling queenside" do
        it "queenside castling white with no blocking pieces" do
          test_castling(ChessPieces::WHITE_PIECES, 1, 0, -2)
        end

        it "queenside castling black with no blocking pieces" do
          test_castling(ChessPieces::BLACK_PIECES, 8, 56, -2)
        end 
        
        context "blocking pieces prevent queenside castling white" do
          context "rook" do
            letters[1..3].each do |l|
              numbers[0..0].each do |n|
                it "queenside castling white with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                end
              end
            end
          end
        end

        context "blocking pieces prevent queenside castling black" do
          context "rook" do
            letters[1..3].each do |l|
              numbers[7..7].each do |n|
                it "queenside castling fail black with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                end
              end
            end
          end
        end

        context "threatening pieces prevent queenside castling white" do
          context "rook" do
            letters[2..4].each do |l|
              numbers[1..7].each do |n|
                it "queenside castling white with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                end
              end
            end
          end
  
          context "knight" do
            letters.reject { |letters| letters == "d" || letters == "h" }.each do |l|
              numbers[1..1].each do |n|
                it "queenside castling white with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                end
              end
            end
  
            letters.reject { |letters| letters == "a" || letters == "g" || letters == "h" }.each do |l|
              numbers[2..2].each do |n|
                it "queenside castling white with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                end
              end
            end
          end
  
          context "pawn" do
            letters[1..5].each do |l|
              numbers[1..1].each do |n|
                it "queenside castling white with pawn piece on #{l}#{n}" do
                  input_pawn(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[5])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                end
              end
            end
          end
  
          context "queen" do
            letters[2..4].each do |l|
              numbers[1..7].each do |n|
                it "queenside castling white with queen piece on #{l}#{n}" do
                  input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[3])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                end
              end
            end
  
            shift_factor[0..2].each do |num|
              letters[4 + num..4 + num].each do |l|
                numbers[0 + num..2 + num].each do |n|
                  it "queenside castling white with queen piece on #{l}#{n}" do
                    input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[3])
                    test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                  end
                end
              end
            end
  
            shift_factor[0..1].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[3 - num..5 - num].each do |n|
                  it "queenside castling white with queen piece on #{l}#{n}" do
                    input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[3])
                    test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 0, -2)
                  end
                end
              end
            end
          end
        end
        
        context "threatening pieces prevent queenside castling black" do
          context "rook" do
            letters[2..4].each do |l|
              numbers[0..6].each do |n|
                it "queenside castling black with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                end
              end
            end
          end

          context "knight" do
            letters.reject { |letters| letters == "d" || letters == "h" }.each do |l|
              numbers[6..6].each do |n|
                it "queenside castling white with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 0, -2)
                end
              end
            end
                
            letters.reject { |letters| letters == "a" || letters == "g" || letters == "h" }.each do |l|
              numbers[5..5].each do |n|
                it "queenside castling white with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 0, -2)
                end
              end
            end
          end

          context "bishop" do
            shift_factor[0..2].each do |num|
              letters[4 + num..4 + num].each do |l|
                numbers[5 - num..7 - num].each do |n|
                  it "queenside castling black with bishop piece on #{l}#{n}" do
                    input_bishop(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[2])
                    test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                  end
                end
              end
            end

            shift_factor[0..1].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[2 + num..4 + num].each do |n|
                  it "queenside castling black with bishop piece on #{l}#{n}" do
                    input_bishop(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[2])
                    test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                  end
                end
              end
            end
          end

          context "pawn" do 
            letters[1..5].each do |l|
              numbers[6..6].each do |n|
                it "queenside castling black with queen piece on #{l}#{n}" do
                  input_pawn(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[5])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                end
              end
            end
          end

          context "queen" do
            letters[2..4].each do |l|
              numbers[0..6].each do |n|
                it "queenside castling black with queen piece on #{l}#{n}" do
                  input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[3])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                end
              end
            end

            shift_factor[0..2].each do |num|
              letters[4 + num..4 + num].each do |l|
                numbers[5 - num..7 - num].each do |n|
                  it "queenside castling black with queen piece on #{l}#{n}" do
                    input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[3])
                    test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                  end
                end
              end
            end

            shift_factor[0..1].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[2 + num..4 + num].each do |n|
                  it "queenside castling black with queen piece on #{l}#{n}" do
                    input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[3])
                    test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 56, -2)
                  end
                end
              end
            end
          end
        end
      end

      context "castling kingside" do
        it "kingside castling white with no blocking pieces" do
          test_castling(ChessPieces::WHITE_PIECES, 1, 7, 2)
        end

        it "kingside castling black with no blocking pieces" do
          test_castling(ChessPieces::BLACK_PIECES, 8, 63, 2)
        end

        context "blocking pieces prevent kingside castling white" do
          context "rook" do
            letters[5..6].each do |l|
              numbers[0..0].each do |n|
                it "kingside castling white with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end
          end
        end

        context "blocking pieces prevent kingside castling white" do
          context "rook" do
            letters[5..6].each do |l|
              numbers[7..7].each do |n|
                it "kingside castling black with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end
          end
        end

        context "threatening pieces prevent kingside castling white" do
          context "rook" do
            letters[4..6].each do |l|
              numbers[1..7].each do |n|
                it "kingside castling white with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end
          end

          context "knight" do
            letters.reject { |letters| letters == "a" || letters == "b" || letters == "f" }.each do |l|
              numbers[1..1].each do |n|
                it "queenside castling white with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end

            letters[3..7].each do |l|
              numbers[2..2].each do |n|
                it "queenside castling white with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end
          end

          context "bishop" do
            letters[7..7].each do |l|
              numbers[1..3].each do |n|
                it "kingside castling white with bishop piece on #{l}#{n}" do
                  input_bishop(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[2])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end

            shift_factor[0..3].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[5 - num..7 - num].each do |n|
                  it "kingkside castling white with bishop piece on #{l}#{n}" do
                    input_bishop(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[2])
                    test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                  end
                end
              end
            end
          end

          context "queen" do
            letters[4..6].each do |l|
              numbers[1..7].each do |n|
                it "kingside castling white with queen piece on #{l}#{n}" do
                  input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[3])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end
               
            letters[7..7].each do |l|
              numbers[1..3].each do |n|
                it "kingside castling white with queen piece on #{l}#{n}" do
                  input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[3])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end
               
            shift_factor[0..3].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[5 - num..7 - num].each do |n|
                  it "kingside castling white with queen piece on #{l}#{n}" do
                    input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[3])
                    test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                  end
                end
              end
            end
          end

          context "pawn" do
            letters[3..7].each do |l|
              numbers[1..1].each do |n|
                it "queenside castling white with pawn piece on #{l}#{n}" do
                  input_pawn(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::BLACK_PIECES[5])
                  test_castling_threatening_pieces(ChessPieces::WHITE_PIECES, 1, 7, 2)
                end
              end
            end
          end
        end

        context "threatening pieces prevent kingside castling black" do
          context "rook" do
            letters[4..6].each do |l|
              numbers[0..6].each do |n|
                it "kingside castling black with rook piece on #{l}#{n}" do
                  input_rook(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[0])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end
          end

          context "knight" do
            letters.reject { |letters| letters == "a" || letters == "b" || letters == "f" }.each do |l|
              numbers[6..6].each do |n|
                it "queenside castling black with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end

            letters[3..7].each do |l|
              numbers[5..5].each do |n|
                it "queenside castling black with knight piece on #{l}#{n}" do
                  input_knight(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[1])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end
          end

          context "bishop" do
            letters[7..7].each do |l|
              numbers[4..6].each do |n|
                it "kingside castling black with bishop piece on #{l}#{n}" do
                  input_bishop(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[2])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end

            shift_factor[0..3].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[0 + num..2 + num].each do |n|
                  it "kingside castling black with bishop piece on #{l}#{n}" do
                    input_bishop(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[2])
                    test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                  end
                end
              end
            end
          end

          context "pawn" do
            letters[3..7].each do |l|
              numbers[6..6].each do |n|
                it "queenside castling black with pawn piece on #{l}#{n}" do
                  input_pawn(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[5])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end
          end

          context "queen" do
            letters[4..6].each do |l|
              numbers[0..6].each do |n|
                it "kingside castling black with queen piece on #{l}#{n}" do
                  input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[3])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end
          
            letters[7..7].each do |l|
              numbers[4..6].each do |n|
                it "kingside castling black with queen piece on #{l}#{n}" do
                  input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[3])
                  test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                end
              end
            end
          
            shift_factor[0..3].each do |num|
              letters[-1 + num..-1 + num].each do |l|
                numbers[0 + num..2 + num].each do |n|
                  it "kingkside castling black with queen piece on #{l}#{n}" do
                    input_queen(convert_coordinates_to_num(generate_coordinates(n, l)), ChessPieces::WHITE_PIECES[3])
                    test_castling_threatening_pieces(ChessPieces::BLACK_PIECES, 8, 63, 2)
                  end
                end
              end
            end
          end
        end
      end
    end

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

        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces downwards" do
          letters.each do |l|
            numbers[1..numbers.length - 1].each do |n|
              it "move from #{l}#{n} to #{l}#{n - 1}" do
                test_without_blocking_pieces(n, l, -1, 0, king, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces right" do
          letters[0..letters.length - 2].each do |l|
            numbers.each do |n|
              it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n}" do
                test_without_blocking_pieces(n, l, 0, 1, king, &change_in_origin_and_destination)
              end
            end
          end
        end
        
        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces left" do
          letters[1..letters.length - 1].each do |l|
            numbers.each do |n|
              it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n}" do
                test_without_blocking_pieces(n, l, 0, -1, king, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up right" do
          letters[0..letters.length - 2].each do |l|
            numbers[0..letters.length - 2].each do |n|
              it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n + 1}" do
                test_without_blocking_pieces(n, l, 1, 1, king, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally up left" do
          letters[1..letters.length - 1].each do |l|
            numbers[0..letters.length - 2].each do |n|
              it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n + 1}" do
                test_without_blocking_pieces(n, l, 1, -1, king, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down right" do
          letters[0..letters.length - 2].each do |l|
            numbers[1..letters.length - 1].each do |n|
              it "move from #{l}#{n} to #{(l.ord + 1).chr}#{n - 1}" do
                test_without_blocking_pieces(n, l, -1, 1, king, &change_in_origin_and_destination)
              end
            end
          end
        end

        context "moves #{(idx.zero?) ? 'white king' : 'black king'} #{1} spaces diagonally down left" do
          letters[1..letters.length - 1].each do |l|
            numbers[1..letters.length - 1].each do |n|
              it "move from #{l}#{n} to #{(l.ord - 1).chr}#{n - 1}" do
                test_without_blocking_pieces(n, l, -1, -1, king, &change_in_origin_and_destination)
              end
            end
          end
        end 
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