$LOAD_PATH << "#{File.expand_path("../../../lib/chess_pieces", __FILE__)}"
require 'knight'
require 'generate_moves'

describe Knight do
  include GenerateMoves
  let(:knight) { Knight.new("\u2656".encode('utf-8')) }

  def possible_moves(n)
    possible_moves = []
    generate_knight_left_moves(n, possible_moves)
    generate_knight_right_moves(n, possible_moves)
  end

  def generate_knight_left_moves(n, possible_moves)
    possible_moves << n + 17 if n % 8 < 7 && n < 56
    possible_moves << n + 10 if n % 8 < 6 && n < 48
    possible_moves << n - 6 if n % 8 < 6 && n > 7
    possible_moves << n - 15 if n % 8 < 7 && n > 15
    possible_moves
  end

  def generate_knight_right_moves(n, possible_moves)
    possible_moves << n + 15 if n % 8 > 0 && n < 56
    possible_moves << n + 6 if n % 8 > 1 && n < 48 
    possible_moves << n - 10 if n % 8 > 1 && n > 7
    possible_moves << n - 17 if n % 8 > 0 && n > 15
    possible_moves
  end

  context "#all_possible_moves" do
    it "total possible starting positions" do
      expect(knight.all_possible_moves.length).to eql(64)
    end

    context "returns the exact array of possible moves for each starting position" do
      (0..63).each do |n|
        it "position #{n}" do
          expect(knight.all_possible_moves[0].possible_moves).to match_array(possible_moves(0))
        end
      end
    end
  end
end