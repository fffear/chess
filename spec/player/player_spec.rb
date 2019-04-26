$: << "#{File.expand_path('../../../lib/player', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chessboard', __FILE__)}"
$: << "#{File.expand_path('../../../lib/chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../../lib/move_pieces', __FILE__)}"

require 'chessboard'
require 'player'
require 'chess_pieces'
require 'rook'
require 'move_rook'

describe Player do
  let(:chessboard) { Chessboard.new }
  player_1 = Player.new("white", ChessPieces::WHITE_PIECES)
  player_2 = Player.new("white", ChessPieces::BLACK_PIECES)



  describe "#move_piece" do
    
    it "moves a black piece" do
      chessboard.board[0].piece = Rook.new(ChessPieces::BLACK_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::BLACK_PIECES[0])}.to change {chessboard.board[0].piece}.and change {chessboard.board[56].piece}
    end

    it "fails to move a white piece as the black player" do
      chessboard.board[0].piece = Rook.new(ChessPieces::BLACK_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::WHITE_PIECES[0])}.to_not change {chessboard.board[0].piece} #.and change {chessboard.board[56].piece}
    end

    it "moves a white piece" do
      chessboard.board[0].piece = Rook.new(ChessPieces::WHITE_PIECES[0])
      expect {player_1.move_piece("a1", "a8", chessboard, ChessPieces::WHITE_PIECES[0])}.to change {chessboard.board[0].piece}.and change {chessboard.board[56].piece}
    end

    it "fails to move a black piece as the white player" do
      chessboard.board[0].piece = Rook.new(ChessPieces::WHITE_PIECES[0])
      expect {player_2.move_piece("a1", "a8", chessboard, ChessPieces::BLACK_PIECES[0])}.to_not change {chessboard.board[0].piece} #.and change {chessboard.board[56].piece}
    end
  end
end