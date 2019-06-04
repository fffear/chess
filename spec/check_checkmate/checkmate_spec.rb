$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/check', __FILE__)}"
$: << "#{File.expand_path('../../../lib/check/checkmate_condition', __FILE__)}"

require 'chess'
require 'chess_pieces'
require 'coordinates'
require 'checkmate'

describe CheckMate do
  include Coordinates
  include ChessPieces
  let(:chess) { Chess.new }
  let(:check_mate_white) { CheckMate.new(chess.board, ChessPieces::WHITE_PIECES, 0) }
  let(:check_mate_black) { CheckMate.new(chess.board, ChessPieces::BLACK_PIECES, 0) }
  
  def input_king(tile_num, king_piece)
    chess.board.board[tile_num].piece = King.new(king_piece)
  end

  def input_queen(tile_num, queen_piece)
    chess.board.board[tile_num].piece = Queen.new(queen_piece)
  end


  describe "#compute" do
    it "return true when king can't make a legal move" do
      input_king(59, ChessPieces::BLACK_PIECES[4])
      input_king(43, ChessPieces::WHITE_PIECES[4])
      input_queen(63, Chess::WHITE_PIECES[3])
      expect(check_mate_black.compute).to be true
    end

    it "return false when king can make a legal move" do
      input_king(59, ChessPieces::BLACK_PIECES[4])
      input_queen(51, ChessPieces::WHITE_PIECES[3])
      input_queen(63, Chess::WHITE_PIECES[3])
      expect(check_mate_black.compute).to be false
    end

    it "return false when the path of the threatening piece can be blocked" do
      input_king(59, ChessPieces::BLACK_PIECES[4])
      input_king(43, ChessPieces::WHITE_PIECES[4])
      input_queen(63, Chess::WHITE_PIECES[3])
      input_queen(6, Chess::BLACK_PIECES[3])
      expect(check_mate_black.compute).to be false
    end
  end
end