$LOAD_PATH << "#{File.expand_path("../../../lib/chessboard", __FILE__)}"
require 'chessboard.rb'

describe Chessboard do
  let(:board) { Chessboard.new }

  context "#chessboard" do
    it "returns a board with 64 tiles" do
      expect(board.chessboard.length).to eql(64)
    end
  end


end