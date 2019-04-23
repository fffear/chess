$LOAD_PATH << "#{File.expand_path("../../../lib/chess_pieces", __FILE__)}"
require 'pawn'
require 'generate_moves'

describe WhitePawn do
  include GenerateMoves
  let(:pawn) { WhitePawn.new("\u2656".encode('utf-8')) }

  def possible_moves(n)
    possible_moves = []
    [8, 16].each { |num| possible_moves << n + num  if n / 8 == 1 }
    possible_moves << n + 8 if n / 8 != 1
    possible_moves << n + 9 if n % 8 != 7
    possible_moves << n + 7 if n % 8 != 0
    possible_moves
  end

  context "returns the exact array of possible moves for each starting position" do
    (8..55).each do |n|
      it "position #{n}" do
        expect(pawn.all_possible_moves[n].possible_moves).to match_array(possible_moves(n))
      end
    end
  end
end

describe BlackPawn do
  include GenerateMoves
  let(:pawn) { BlackPawn.new("\u2656".encode('utf-8')) }

  def possible_moves(n)
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
        expect(pawn.all_possible_moves[n].possible_moves).to match_array(possible_moves(n))
      end
    end
  end
end