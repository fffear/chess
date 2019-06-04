$: << "#{File.expand_path('../../../lib/player', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chessboard', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"

require 'chessboard'
require 'player'
require 'chess_pieces'
require 'rook'
require 'knight'
require 'bishop'
require 'queen'
require 'king'
require 'pawn'
require 'move_rook'
require 'move_knight'
require 'move_bishop'
require 'move_queen'
require 'move_king'
require 'move_pawn'

describe Player do
  let(:chessboard) { Chessboard.new }
  player_1 = Player.new("white", ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES)
  player_2 = Player.new("black", ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES)

  describe "#move_piece" do
    it "moves a black rook piece" do
      chessboard.board[0].piece = Rook.new(ChessPieces::BLACK_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[56].piece}
    end

    it "fails to move a black rook piece as the white player" do
      chessboard.board[0].piece = Rook.new(ChessPieces::BLACK_PIECES[0])
      expect {player_1.move_piece("a1", "a8", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a white rook piece" do
      chessboard.board[0].piece = Rook.new(ChessPieces::WHITE_PIECES[0])
      expect {player_1.move_piece("a1", "a8", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[56].piece}
    end

    it "fails to move a white rook piece as the black player" do
      chessboard.board[0].piece = Rook.new(ChessPieces::WHITE_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a black knight piece" do
      chessboard.board[0].piece = Knight.new(ChessPieces::BLACK_PIECES[1])
      expect {player_2.move_piece("a1", "b3", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[17].piece}
    end

    it "fails to move a black knight piece as the white player" do
      chessboard.board[0].piece = Knight.new(ChessPieces::BLACK_PIECES[1])
      expect {player_2.move_piece("a1", "b3", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a white knight piece" do
      chessboard.board[0].piece = Knight.new(ChessPieces::WHITE_PIECES[1])
      expect {player_1.move_piece("a1", "b3", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[17].piece}
    end

    it "fails to move a white knight piece as the black player" do
      chessboard.board[0].piece = Knight.new(ChessPieces::WHITE_PIECES[1])
      expect {player_2.move_piece("a1", "b3", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a black bishop piece" do
      chessboard.board[0].piece = Bishop.new(ChessPieces::BLACK_PIECES[2])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[9].piece}
    end

    it "fails to move a black bishop piece as the white player" do
      chessboard.board[0].piece = Bishop.new(ChessPieces::BLACK_PIECES[2])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a white bishop piece" do
      chessboard.board[0].piece =Bishop.new(ChessPieces::WHITE_PIECES[2])
      expect {player_1.move_piece("a1", "b2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[9].piece}
    end

    it "fails to move a white bishop piece as the black player" do
      chessboard.board[0].piece = Bishop.new(ChessPieces::WHITE_PIECES[2])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a black queen piece" do
      chessboard.board[0].piece = Queen.new(ChessPieces::BLACK_PIECES[3])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[9].piece}
    end

    it "fails to move a black queen piece as the white player" do
      chessboard.board[0].piece = Queen.new(ChessPieces::BLACK_PIECES[3])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a white queen piece" do
      chessboard.board[0].piece = Queen.new(ChessPieces::WHITE_PIECES[3])
      expect {player_1.move_piece("a1", "b2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[9].piece}
    end

    it "fails to move a white queen piece as the black player" do
      chessboard.board[0].piece = Queen.new(ChessPieces::WHITE_PIECES[3])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a black king piece" do
      chessboard.board[0].piece = King.new(ChessPieces::BLACK_PIECES[4])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[9].piece}
    end

    it "fails to move a black king piece as the white player" do
      chessboard.board[0].piece = King.new(ChessPieces::BLACK_PIECES[4])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a white king piece" do
      chessboard.board[0].piece = King.new(ChessPieces::WHITE_PIECES[4])
      expect {player_1.move_piece("a1", "b2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[9].piece}
    end

    it "fails to move a white king piece as the black player" do
      chessboard.board[0].piece = King.new(ChessPieces::WHITE_PIECES[4])
      expect {player_2.move_piece("a1", "b2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to_not change {chessboard.board[0].piece}
    end

    it "moves a black pawn piece" do
      chessboard.board[16].piece = Pawn.new(ChessPieces::BLACK_PIECES[5], 48)
      expect {player_2.move_piece("a3", "a2", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[16].piece}.and change {chessboard.board[8].piece}
    end

    it "fails to move a black pawn piece as the white player" do
      chessboard.board[16].piece = Pawn.new(ChessPieces::BLACK_PIECES[5], 48)
      expect {player_2.move_piece("a3", "a2", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[16].piece}
    end

    it "moves a white pawn piece" do
      chessboard.board[8].piece = Pawn.new(ChessPieces::WHITE_PIECES[5], 8)
      expect {player_1.move_piece("a2", "a3", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[8].piece}.and change {chessboard.board[16].piece}
    end

    it "fails to move a white pawn piece as the black player" do
      chessboard.board[8].piece = Pawn.new(ChessPieces::WHITE_PIECES[5], 8)
      expect {player_2.move_piece("a2", "a3", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to_not change {chessboard.board[8].piece}
    end
  end
end