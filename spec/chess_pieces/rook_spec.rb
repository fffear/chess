$LOAD_PATH << "#{File.expand_path("../../../lib/chess_pieces", __FILE__)}"
require 'rook'
require 'generate_moves'

describe Rook do
  include GenerateMoves
  let(:rook) { Rook.new("\u2656".encode('utf-8')) }

  def possible_moves(n)
    possible_moves = []
    starting_column(n).step(8) { |node| possible_moves << node unless node == n }
    starting_row(n).each { |node| possible_moves << node unless node == n }
    possible_moves
  end

  context "#all_possible_moves" do
    it "total possible starting positions" do
      expect(rook.all_possible_moves.length).to eql(64)
    end

    context "returns 14 possible moves for each starting position" do
      (0..63).each do |n|
        it "position #{n}" do
          expect(rook.all_possible_moves[n].possible_moves.length).to eql(14)
        end
      end
    end

    context "returns the exact array of possible moves for each starting position" do
      (0..63).each do |n|
        it "position #{n}" do
          expect(rook.all_possible_moves[n].possible_moves).to match_array(possible_moves(n))
        end
      end
    end
  end
end