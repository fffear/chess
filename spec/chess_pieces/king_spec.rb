$LOAD_PATH << "#{File.expand_path("../../../lib/chess_pieces", __FILE__)}"
require 'king'
require 'generate_moves'

describe King do
  include GenerateMoves
  let(:king) { King.new("\u2656".encode('utf-8')) }

  def possible_moves(n)
    possible_moves = []
    generate_horizontal_moves(n, possible_moves)
    generate_vertical_moves(n, possible_moves)
    generate_up_right_moves(n, possible_moves)
    generate_up_left_moves(n, possible_moves)
  end

  def generate_horizontal_moves(n, possible_moves)
    possible_moves << n + 1 if n % 8 != 7
    possible_moves << n - 1 if n % 8 != 0
    possible_moves
  end

  def generate_vertical_moves(n, possible_moves)
    possible_moves << n + 8 if n < 56
    possible_moves << n - 8 if n > 7
    possible_moves
  end

  def generate_up_right_moves(n, possible_moves)
    possible_moves << n + 9 if n % 8 != 7 && n < 56
    possible_moves << n - 9 if n % 8 != 0 && n > 7
    possible_moves
  end

  def generate_up_left_moves(n, possible_moves)
    possible_moves << n + 7 if n % 8 != 0 && n < 56
    possible_moves << n - 7 if n % 8 != 7 && n > 7
    possible_moves
  end

  context "#all_possible_moves" do
    it "total possible starting positions" do
      expect(king.all_possible_moves.length).to eql(64)
    end

    context "returns the exact array of possible moves for each starting position" do
      (0..63).each do |n|
       it "position #{n}" do
         expect(king.all_possible_moves[n].possible_moves).to match_array(possible_moves(n))
       end
      end
    end
  end
end