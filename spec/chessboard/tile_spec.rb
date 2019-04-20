$LOAD_PATH << "#{File.expand_path("../../../lib/chessboard", __FILE__)}"
require 'tile.rb'

describe Tile do
  let(:tile) { Tile.new(["a", 1], " ") }

  context "#coordinates" do
    it "returns an array with a length of 2" do
      expect(tile.coordinates.length).to eql(2)
    end
  end

  context "#piece" do
    it "returns a reassigned string that is not blank when previously blank" do
      tile.piece = "A"
      expect(tile.piece).not_to include(" ")
    end

    it "returns a reassigned string that is blank when previously not blank" do
      tile.piece = "A"
      tile.piece = " "
      expect(tile.piece).to eql(" ")
    end
  end
end
