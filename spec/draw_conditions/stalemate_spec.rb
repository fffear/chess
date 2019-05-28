$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/check', __FILE__)}"
$: << "#{File.expand_path('../../../lib/check/checkmate_condition', __FILE__)}"
$: << "#{File.expand_path('../../../lib/draw_conditions', __FILE__)}"

require 'play_game'
require 'chess_pieces'
require 'coordinates'
require 'checkmate'
require 'stalemate'

describe Stalemate do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:stalemate_white) { Stalemate.new(chess.board, ChessPieces::WHITE_PIECES, 0) }
  let(:stalemate_black) { Stalemate.new(chess.board, ChessPieces::BLACK_PIECES, 0) }
  
  def input_king(tile_num, king_piece)
    chess.board.board[tile_num].piece = King.new(king_piece)
  end

  def input_queen(tile_num, queen_piece)
    chess.board.board[tile_num].piece = Queen.new(queen_piece)
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

  def input_pawn(tile_num, pawn_piece)
    chess.board.board[tile_num].piece = Pawn.new(pawn_piece, tile_num)
  end

  describe "#compute" do
    it "returns true when king is not in check but player can't make a legal move" do
      input_king(63, ChessPieces::BLACK_PIECES[4])
      input_king(47, ChessPieces::WHITE_PIECES[4])
      input_rook(6, ChessPieces::WHITE_PIECES[0])
      expect(stalemate_black.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(63, ChessPieces::BLACK_PIECES[4])
      input_king(47, ChessPieces::WHITE_PIECES[4])
      input_knight(52, ChessPieces::WHITE_PIECES[1])
      expect(stalemate_black.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(63, ChessPieces::BLACK_PIECES[4])
      input_king(47, ChessPieces::WHITE_PIECES[4])
      input_bishop(8, ChessPieces::WHITE_PIECES[2])
      expect(stalemate_black.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(63, ChessPieces::BLACK_PIECES[4])
      input_king(47, ChessPieces::WHITE_PIECES[4])
      input_queen(8, ChessPieces::WHITE_PIECES[3])
      expect(stalemate_black.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(63, ChessPieces::BLACK_PIECES[4])
      input_king(47, ChessPieces::WHITE_PIECES[4])
      input_queen(6, ChessPieces::WHITE_PIECES[3])
      expect(stalemate_black.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(63, ChessPieces::BLACK_PIECES[4])
      input_king(47, ChessPieces::WHITE_PIECES[4])
      input_pawn(53, ChessPieces::WHITE_PIECES[5])
      expect(stalemate_black.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(7, ChessPieces::WHITE_PIECES[4])
      input_king(23, ChessPieces::BLACK_PIECES[4])
      input_rook(62, ChessPieces::BLACK_PIECES[0])
      chess.board.print_board
      expect(stalemate_white.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(7, ChessPieces::WHITE_PIECES[4])
      input_king(23, ChessPieces::BLACK_PIECES[4])
      input_knight(12, ChessPieces::BLACK_PIECES[1])
      chess.board.print_board
      expect(stalemate_white.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(7, ChessPieces::WHITE_PIECES[4])
      input_king(23, ChessPieces::BLACK_PIECES[4])
      input_bishop(48, ChessPieces::BLACK_PIECES[2])
      expect(stalemate_white.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(7, ChessPieces::WHITE_PIECES[4])
      input_king(23, ChessPieces::BLACK_PIECES[4])
      input_queen(48, ChessPieces::BLACK_PIECES[3])
      expect(stalemate_white.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(7, ChessPieces::WHITE_PIECES[4])
      input_king(23, ChessPieces::BLACK_PIECES[4])
      input_queen(62, ChessPieces::BLACK_PIECES[3])
      expect(stalemate_white.compute).to be true
    end

    it "returns true when king is not in check but player can't make a legal move" do
      input_king(7, ChessPieces::WHITE_PIECES[4])
      input_king(23, ChessPieces::BLACK_PIECES[4])
      input_pawn(13, ChessPieces::BLACK_PIECES[5])
      expect(stalemate_white.compute).to be true
    end
  end
end