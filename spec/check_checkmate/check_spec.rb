$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/check', __FILE__)}"

require 'play_game'
require 'chess_pieces'
require 'coordinates'
require 'check'

describe Check do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:check_white) { Check.new(chess.board, ChessPieces::WHITE_PIECES) }
  let(:check_black) { Check.new(chess.board, ChessPieces::BLACK_PIECES) }

  def input_king(tile_num, king_piece)
    chess.board.board[tile_num].piece = King.new(king_piece)
  end

  def input_rook(tile_num, rook_piece)
    chess.board.board[tile_num].piece = Rook.new(rook_piece)
  end

  def input_knight(tile_num, knight_piece)
    chess.board.board[tile_num].piece = Knight.new(knight_piece)
  end

  def input_bishop(tile_num, bishop_piece)
    chess.board.board[tile_num].piece = Bishop.new(bishop_piece)
  end

  def input_queen(tile_num, queen_piece)
    chess.board.board[tile_num].piece = Queen.new(queen_piece)
  end

  def input_pawn(tile_num, pawn_piece)
    chess.board.board[tile_num].piece = Pawn.new(pawn_piece, 1)
  end

  def test_for_white_king_check_vertically(l, n, kl)
    input_rook(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[0])
    input_king(convert_coordinates_to_num("#{l}#{kl}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_vertically(l, n, kl)
    input_rook(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[0])
    input_king(convert_coordinates_to_num("#{l}#{kl}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_horizontally(l, n, kl)
    input_rook(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[0])
    input_king(convert_coordinates_to_num("#{kl}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_horizontally(l, n, kl)
    input_rook(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[0])
    input_king(convert_coordinates_to_num("#{kl}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_vertically_by_queen(l, n, kl)
    input_rook(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[3])
    input_king(convert_coordinates_to_num("#{l}#{kl}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_vertically_by_queen(l, n, kl)
    input_rook(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[3])
    input_king(convert_coordinates_to_num("#{l}#{kl}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_horizontally_by_queen(l, n, kl)
    input_queen(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[3])
    input_queen(convert_coordinates_to_num("#{kl}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_horizontally_by_queen(l, n, kl)
    input_queen(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[3])
    input_king(convert_coordinates_to_num("#{kl}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_king_in_check_by_queen_vertically(l, n, kl, color)
    (color == "white") ? test_for_white_king_check_vertically_by_queen(l, n, kl) : test_for_black_king_check_vertically_by_queen(l, n, kl)
  end

  def test_for_king_in_check_by_queen_horizontally(l, n, kl, color)
    (color == "white") ? test_for_white_king_check_horizontally_by_queen(l, n, kl) : test_for_black_king_check_horizontally_by_queen(l, n, kl)
  end

  def test_for_king_in_check_by_rook_vertically(l, n, kl, color)
    (color == "white") ? test_for_white_king_check_vertically(l, n, kl) : test_for_black_king_check_vertically(l, n, kl)
  end

  def test_for_king_in_check_by_rook_horizontally(l, n, kl, color)
    (color == "white") ? test_for_white_king_check_horizontally(l, n, kl) : test_for_black_king_check_horizontally(l, n, kl)
  end

  def test_for_white_king_check_diagonally_up_right_by_queen(l, n, kl, sf)
    input_queen(convert_coordinates_to_num("#{(l.ord + sf).chr}#{n + sf}"), ChessPieces::BLACK_PIECES[3])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_diagonally_up_right_by_queen(l, n, kl, sf)
    input_queen(convert_coordinates_to_num("#{(l.ord + sf).chr}#{n + sf}"), ChessPieces::WHITE_PIECES[3])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_diagonally_up_left_by_queen(l, n, kl, sf)
    input_queen(convert_coordinates_to_num("#{(l.ord - sf).chr}#{n + sf}"), ChessPieces::BLACK_PIECES[3])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_diagonally_up_left_by_queen(l, n, kl, sf)
    input_queen(convert_coordinates_to_num("#{(l.ord - sf).chr}#{n + sf}"), ChessPieces::WHITE_PIECES[3])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_king_in_check_by_queen_diagonally_up_right(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_diagonally_up_right_by_queen(l, n, kl, sf) : test_for_black_king_check_diagonally_up_right_by_queen(l, n, kl, sf)
  end

  def test_for_king_in_check_by_queen_diagonally_up_left(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_diagonally_up_left_by_queen(l, n, kl, sf) : test_for_black_king_check_diagonally_up_left_by_queen(l, n, kl, sf)
  end

  def test_for_white_king_check_diagonally_up_right_by_bishop(l, n, kl, sf)
    input_bishop(convert_coordinates_to_num("#{(l.ord + sf).chr}#{n + sf}"), ChessPieces::BLACK_PIECES[2])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_diagonally_up_right_by_bishop(l, n, kl, sf)
    input_bishop(convert_coordinates_to_num("#{(l.ord + sf).chr}#{n + sf}"), ChessPieces::WHITE_PIECES[2])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_diagonally_up_left_by_bishop(l, n, kl, sf)
    input_bishop(convert_coordinates_to_num("#{(l.ord - sf).chr}#{n + sf}"), ChessPieces::BLACK_PIECES[2])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_diagonally_up_left_by_bishop(l, n, kl, sf)
    input_bishop(convert_coordinates_to_num("#{(l.ord - sf).chr}#{n + sf}"), ChessPieces::WHITE_PIECES[2])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_king_in_check_by_bishop_diagonally_up_right(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_diagonally_up_right_by_bishop(l, n, kl, sf) : test_for_black_king_check_diagonally_up_right_by_bishop(l, n, kl, sf)
  end

  def test_for_king_in_check_by_bishop_diagonally_up_left(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_diagonally_up_left_by_bishop(l, n, kl, sf) : test_for_black_king_check_diagonally_up_left_by_bishop(l, n, kl, sf)
  end

  def test_for_white_king_check_two_up_one_right_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord + sf).chr}#{n + (2 * sf)}"), ChessPieces::BLACK_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_two_up_one_right_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord + sf).chr}#{n + (2 * sf)}"), ChessPieces::WHITE_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_one_up_two_right_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord + (2 * sf)).chr}#{n + sf}"), ChessPieces::BLACK_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_one_up_two_right_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord + (2 * sf)).chr}#{n + sf}"), ChessPieces::WHITE_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_one_up_two_left_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord - (2 * sf)).chr}#{n + sf}"), ChessPieces::BLACK_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_one_up_two_left_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord - (2 * sf)).chr}#{n + sf}"), ChessPieces::WHITE_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_white_king_check_two_up_one_left_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord - sf).chr}#{n + (2 * sf)}"), ChessPieces::BLACK_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
    expect(check_white.compute).to be true
  end

  def test_for_black_king_check_two_up_one_left_by_knight(l, n, kl, sf)
    input_knight(convert_coordinates_to_num("#{(l.ord - sf).chr}#{n + (2 * sf)}"), ChessPieces::WHITE_PIECES[1])
    input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
    expect(check_black.compute).to be true
  end

  def test_for_king_in_check_by_knight_two_up_one_right(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_two_up_one_right_by_knight(l, n, kl, sf) : test_for_black_king_check_two_up_one_right_by_knight(l, n, kl, sf)
  end

  def test_for_king_in_check_by_knight_one_up_two_right(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_one_up_two_right_by_knight(l, n, kl, sf) : test_for_black_king_check_one_up_two_right_by_knight(l, n, kl, sf)
  end

  def test_for_king_in_check_by_knight_one_up_two_left(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_one_up_two_left_by_knight(l, n, kl, sf) : test_for_black_king_check_one_up_two_left_by_knight(l, n, kl, sf)
  end

  def test_for_king_in_check_by_knight_two_up_one_left(l, n, kl, sf, color)
    (color == "white") ? test_for_white_king_check_two_up_one_left_by_knight(l, n, kl, sf) : test_for_black_king_check_two_up_one_left_by_knight(l, n, kl, sf)
  end

  describe "#compute" do
    letters = ("a".."h").to_a
    numbers = (1..8).to_a
    shift_factor = (1..7).to_a
    king_location = (1..8).to_a

    context "pawn" do
      letters[0..letters.length - 2].each do |l|
        numbers[0..numbers.length - 3].each do |n|
          it "white king in check on #{l}#{n} by black pawn up right on #{(l.ord + 1).chr}#{n + 1}" do
            input_pawn(convert_coordinates_to_num("#{(l.ord + 1).chr}#{n + 1}"), ChessPieces::BLACK_PIECES[5])
            input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
            expect(check_white.compute).to be true
          end
        end
      end

      letters[1..letters.length - 1].each do |l|
        numbers[0..numbers.length - 3].each do |n|
          it "white king in check on #{l}#{n} by black pawn up right on #{(l.ord - 1).chr}#{n + 1}" do
            input_pawn(convert_coordinates_to_num("#{(l.ord - 1).chr}#{n + 1}"), ChessPieces::BLACK_PIECES[5])
            input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::WHITE_PIECES[4])
            expect(check_white.compute).to be true
          end
        end
      end

      letters[1..letters.length - 1].each do |l|
        numbers[2..numbers.length - 1].each do |n|
          it "black king in check on #{l}#{n} by white pawn down left on #{(l.ord - 1).chr}#{n - 1}" do
            input_pawn(convert_coordinates_to_num("#{(l.ord - 1).chr}#{n - 1}"), ChessPieces::WHITE_PIECES[5])
            input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
            expect(check_black.compute).to be true
          end
        end
      end

      letters[0..letters.length - 2].each do |l|
        numbers[2..numbers.length - 1].each do |n|
          it "black king in check on #{l}#{n} by white pawn down right on #{(l.ord + 1).chr}#{n - 1}" do
            input_pawn(convert_coordinates_to_num("#{(l.ord + 1).chr}#{n - 1}"), ChessPieces::WHITE_PIECES[5])
            input_king(convert_coordinates_to_num("#{l}#{n}"), ChessPieces::BLACK_PIECES[4])
            expect(check_black.compute).to be true
          end
        end
      end
    end

    ["white", "black"].each do |color|
      context "2 tiles up 1 tile right" do
        shift_factor[0..0].each do |sf|
          king_location[0..king_location.length - 3].each do |kl|
            letters[0..letters.length - 2].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord + sf).chr}#{n + (1 + sf)}" do
                  test_for_king_in_check_by_knight_two_up_one_right(l, n, kl, sf, color)
                end
              end
            end
          end 
        end
      end

      context "1 tile up 2 tiles right" do
        shift_factor[0..0].each do |sf|
          king_location[0..king_location.length - 2].each do |kl|
            letters[0..letters.length - 3].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord + 1 + sf).chr}#{n + sf}" do
                  test_for_king_in_check_by_knight_one_up_two_right(l, n, kl, sf, color)
                end
              end
            end
          end 
        end
      end

      context "1 tile up 2 tiles left" do
        shift_factor[0..0].each do |sf|
          king_location[0..king_location.length - 2].each do |kl|
            letters[2..letters.length - 1].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord - 1 -sf).chr}#{n + sf}" do
                  test_for_king_in_check_by_knight_one_up_two_left(l, n, kl, sf, color)
                end
              end
            end
          end 
        end
      end

      context "2 tiles up 1 tile left" do
        shift_factor[0..0].each do |sf|
          king_location[0..king_location.length - 3].each do |kl|
            letters[1..letters.length - 1].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord - sf).chr}#{n + 1 + sf}" do
                  test_for_king_in_check_by_knight_two_up_one_left(l, n, kl, sf, color)
                end
              end
            end
          end 
        end
      end

      context "2 tiles down 1 tile right" do
        shift_factor[0..0].each do |sf|
          king_location[2..king_location.length - 1].each do |kl|
            letters[0..letters.length - 2].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord + sf).chr}#{n - (1 + sf)}" do
                  test_for_king_in_check_by_knight_two_up_one_left(l, n, kl, -sf, color)
                end
              end
            end
          end 
        end
      end

      context "1 tile down 2 tiles right" do
        shift_factor[0..0].each do |sf|
          king_location[1..king_location.length - 1].each do |kl|
            letters[0..letters.length - 3].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord + 1 + sf).chr}#{n - sf}" do
                  test_for_king_in_check_by_knight_one_up_two_left(l, n, kl, -sf, color)
                end
              end
            end
          end 
        end
      end

      context "2 tiles down 1 tile left" do
        shift_factor[0..0].each do |sf|
          king_location[2..king_location.length - 1].each do |kl|
            letters[1..letters.length - 1].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord - sf).chr}#{n - (2 * sf)}" do
                  test_for_king_in_check_by_knight_two_up_one_right(l, n, kl, -sf, color)
                end
              end
            end
          end 
        end
      end

      context "1 tile down 2 tiles left" do
        shift_factor[0..0].each do |sf|
          king_location[1..king_location.length - 1].each do |kl|
            letters[2..letters.length - 1].each do |l|
              numbers[kl - 1..kl - 1].each do |n|
                it "returns true if king is in check on #{l}#{n} and knight is on #{(l.ord - 1 - sf).chr}#{n - sf}" do
                  test_for_king_in_check_by_knight_one_up_two_right(l, n, kl, -sf, color)
                end
              end
            end
          end 
        end
      end
    end

    context "diagonally" do
      ["white", "black"].each do |color|
        context "#{color.capitalize} king in check by bishop" do
          shift_factor.each do |sf|
            king_location[0..king_location.length - (1 + sf)].each do |kl|
              letters[0..letters.length - (1 + sf)].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and Bishop is on #{(l.ord + sf).chr}#{n + sf}" do
                    test_for_king_in_check_by_bishop_diagonally_up_right(l, n, kl, sf, color)
                  end
                end
              end
            end 
          end
          
          shift_factor.each do |sf|
            king_location[sf..king_location.length - 1].each do |kl|
              letters[sf..letters.length - 1].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and Bishop is on #{(l.ord - sf).chr}#{n - sf}" do
                    test_for_king_in_check_by_bishop_diagonally_up_right(l, n, kl, -sf, color)
                  end
                end
              end
            end
          end 
          
          shift_factor.each do |sf|
            king_location[0..king_location.length - (1 + sf)].each do |kl|
              letters[sf..letters.length - 1].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and Bishop is on #{(l.ord - sf).chr}#{n + sf}" do
                    test_for_king_in_check_by_bishop_diagonally_up_left(l, n, kl, sf, color)
                  end
                end
              end
            end
          end
          
          shift_factor.each do |sf|
            king_location[sf..king_location.length - 1].each do |kl|
              letters[0..letters.length - (1 + sf)].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and Bishop is on #{(l.ord + sf).chr}#{n - sf}" do
                    test_for_king_in_check_by_bishop_diagonally_up_left(l, n, kl, -sf, color)
                  end
                end
              end
            end
          end 
        end 

        context "#{color.capitalize} king in check by queen" do
          shift_factor.each do |sf|
            king_location[0..king_location.length - (1 + sf)].each do |kl|
              letters[0..letters.length - (1 + sf)].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and queen is on #{(l.ord + sf).chr}#{n + sf}" do
                    test_for_king_in_check_by_queen_diagonally_up_right(l, n, kl, sf, color)
                  end
                end
              end
            end 
          end
    
          shift_factor.each do |sf|
            king_location[sf..king_location.length - 1].each do |kl|
              letters[sf..letters.length - 1].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and queen is on #{(l.ord - sf).chr}#{n - sf}" do
                    test_for_king_in_check_by_queen_diagonally_up_right(l, n, kl, -sf, color)
                  end
                end
              end
            end
          end 
    
          shift_factor.each do |sf|
            king_location[0..king_location.length - (1 + sf)].each do |kl|
              letters[sf..letters.length - 1].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and queen is on #{(l.ord - sf).chr}#{n + sf}" do
                    test_for_king_in_check_by_queen_diagonally_up_left(l, n, kl, sf, color)
                  end
                end
              end
            end
          end 

          shift_factor.each do |sf|
            king_location[sf..king_location.length - 1].each do |kl|
              letters[0..letters.length - (1 + sf)].each do |l|
                numbers[kl - 1..kl - 1].each do |n|
                  it "returns true if king is in check on #{l}#{n} and queen is on #{(l.ord + sf).chr}#{n - sf}" do
                    test_for_king_in_check_by_queen_diagonally_up_left(l, n, kl, -sf, color)
                  end
                end
              end
            end
          end 
        end
      end
    end    

    context "vertically" do
      ["white", "black"].each do |color|
        context "#{color.capitalize} king in check by rook" do
          king_location[0..king_location.length - 2].each do |kl|
            letters.each do |l|
              numbers[kl..numbers.length - 1].each do |n|
                it "returns true if king is in check on #{l}#{kl} by Rook on #{l}#{n}" do
                  test_for_king_in_check_by_rook_vertically(l, n, kl, color)
                end
              end
            end
          end

          king_location[1..king_location.length - 1].each do |kl|
            letters.each do |l|
              numbers[0..kl - 2].each do |n|
                it "returns true if king is in check on #{l}#{kl} by Rook on #{l}#{n}" do
                  test_for_king_in_check_by_rook_vertically(l, n, kl, color)
                end
              end
            end
          end
        end

        context "#{color.capitalize} king in check by queen" do
          king_location[0..king_location.length - 2].each do |kl|
            letters.each do |l|
              numbers[kl..numbers.length - 1].each do |n|
                it "returns true if king is in check on #{l}#{kl} by Queen on #{l}#{n}" do
                  test_for_king_in_check_by_queen_vertically(l, n, kl, color)
                end
              end
            end
          end

          king_location[1..king_location.length - 1].each do |kl|
            letters.each do |l|
              numbers[0..kl - 2].each do |n|
                it "returns true if king is in check on #{l}#{kl} by Rook on #{l}#{n}" do
                  test_for_king_in_check_by_queen_vertically(l, n, kl, color)
                end
              end
            end
          end
        end
      end
    end

    context "horizontally" do
      ["white", "black"].each do |color|
        context "#{color.capitalize} king in check by rook" do
          letters[0..letters.length - 2].each do |kl|
            numbers[0..numbers.length - 1].each do |n|
              letters[letters.index(kl) + 1..letters.length - 1].each do |l|
                it "returns true when king is in check on #{kl}#{n} by Rook on #{l}#{n}" do
                  test_for_king_in_check_by_rook_horizontally(l, n, kl, color)
                end
              end
            end
          end
        
          letters[1..letters.length - 1].each do |kl|
            numbers[0..numbers.length - 1].each do |n|
              letters[0..letters.index(kl) - 1].each do |l|
                it "returns true when king is in check on #{kl}#{n} by Rook on #{l}#{n}" do
                  test_for_king_in_check_by_rook_horizontally(l, n, kl, color)
                end
              end
            end
          end
        end

        context "#{color.capitalize} king in check by queen" do
          letters[0..letters.length - 2].each do |kl|
            numbers[0..numbers.length - 1].each do |n|
              letters[letters.index(kl) + 1..letters.length - 1].each do |l|
                it "returns true when king is in check on #{kl}#{n} by queen on #{l}#{n}" do
                  test_for_king_in_check_by_queen_horizontally(l, n, kl, color)
                end
              end
            end
          end
        
          letters[1..letters.length - 1].each do |kl|
            numbers[0..numbers.length - 1].each do |n|
              letters[0..letters.index(kl) - 1].each do |l|
                it "returns true when king is in check on #{kl}#{n} by queen on #{l}#{n}" do
                  test_for_king_in_check_by_queen_horizontally(l, n, kl, color)
                end
              end
            end
          end
        end
      end
    end
  end
end

