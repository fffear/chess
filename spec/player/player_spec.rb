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
      chessboard.print_board
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[56].piece}
      chessboard.print_board
    end

    it "fails to move a white rook piece as the black player" do
      chessboard.board[0].piece = Rook.new(ChessPieces::BLACK_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::WHITE_PIECES[0], ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece} #.and change {chessboard.board[56].piece}
    end

    it "moves a white rook piece" do
      chessboard.board[0].piece = Rook.new(ChessPieces::WHITE_PIECES[0])
      expect {player_1.move_piece("a1", "a8", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[56].piece}
    end

    it "fails to move a black rook piece as the white player" do
      chessboard.board[0].piece = Rook.new(ChessPieces::WHITE_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::BLACK_PIECES[0], ChessPieces::WHITE_PIECES, 1)}.to_not change {chessboard.board[0].piece} #.and change {chessboard.board[56].piece}
    end

    it "moves a black knight piece" do
      chessboard.board[0].piece = Knight.new(ChessPieces::BLACK_PIECES[1])
      expect {player_2.move_piece("a1", "b3", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::WHITE_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[17].piece}
    end

    it "fails to move a white knight piece as the black player" do
      chessboard.board[0].piece = Knight.new(ChessPieces::BLACK_PIECES[1])
      expect {player_2.move_piece("a1", "b3", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece} #.and change {chessboard.board[56].piece}
    end

    it "moves a white knight piece" do
      chessboard.board[0].piece = Knight.new(ChessPieces::WHITE_PIECES[1])
      expect {player_1.move_piece("a1", "b3", chessboard, ChessPieces::WHITE_PIECES, ChessPieces::BLACK_PIECES, 1)}.to change {chessboard.board[0].piece}.and change {chessboard.board[17].piece}
    end

    it "fails to move a black knight piece as the white player" do
      chessboard.board[0].piece = Knight.new(ChessPieces::WHITE_PIECES[0])
      expect {player_2.move_piece("a1", "b3", chessboard, ChessPieces::BLACK_PIECES, ChessPieces::BLACK_PIECES, 1)}.to_not change {chessboard.board[0].piece} #.and change {chessboard.board[56].piece}
    end
  end
end