$LOAD_PATH << "#{File.expand_path("../../../lib/chess_pieces", __FILE__)}"
require 'pawn'
require 'generate_moves'

describe Pawn do
  include GenerateMoves
  let(:white_pawn) { Pawn.new("\u2659".encode('utf-8')) }
  let(:black_pawn) { Pawn.new("\u265F".encode('utf-8')) }


  def white_possible_moves(n)
    possible_moves = []
    [8, 16].each { |num| possible_moves << n + num  if n / 8 == 1 }
    possible_moves << n + 8 if n / 8 != 1
    possible_moves << n + 9 if n % 8 != 7
    possible_moves << n + 7 if n % 8 != 0
    possible_moves
  end

  def black_possible_moves(n)
    possible_moves = []
    [-8, -16].each { |num| possible_moves << n + num  if n / 8 == 6 }
    possible_moves << n - 8 if n / 8 != 6
    possible_moves << n - 7 if n % 8 != 7
    possible_moves << n - 9 if n % 8 != 0
    possible_moves
  end

  context "returns the exact array of possible moves for each starting position" do
    (8..55).each do |n|
      it "position #{n}" do
        expect(white_pawn.all_possible_moves[n].possible_moves).to match_array(white_possible_moves(n))
      end
    end
  end

  context "returns the exact array of possible moves for each starting position" do
    (8..55).each do |n|
      it "position #{n}" do
        expect(black_pawn.all_possible_moves[n].possible_moves).to match_array(black_possible_moves(n))
      end
    end
  end
end