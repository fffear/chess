$LOAD_PATH << "#{File.expand_path("../../../lib/chess_pieces", __FILE__)}"
require 'queen'
require 'generate_moves'

describe Queen do
  include GenerateMoves
  let(:queen) { Queen.new("\u2656".encode('utf-8')) }

  def possible_moves(n)
    possible_moves = []
    starting_column(n).step(8) { |node| possible_moves << node unless node == n }
    starting_row(n).each { |node| possible_moves << node unless node == n }
    all_up_right_diagonal_moves_from_a_position(n, possible_moves)
    all_down_left_diagonal_moves_from_a_position(n, possible_moves)
  end

  def all_up_right_diagonal_moves_from_a_position(node_num, array)
    n = node_num
    n -= 9 until n % 8 == 0 || n <= 8
    generate_up_right_diagonal_moves_from_a_position(n, node_num, array)
  end

  def all_down_left_diagonal_moves_from_a_position(node_num, array)
    n = node_num
    n -= 7 until n % 8 == 7 || n <= 7
    generate_down_left_diagonal_moves_from_a_position(n, node_num, array)
  end

  def generate_up_right_diagonal_moves_from_a_position(n, node_num, array)
    (n...64).step(9) do |num|
      break if (num == node_num) && num % 8 == 7
      if num % 8 == 7
        array << num
        break
      end
      (num == node_num) ? next : array << num
    end
    array
  end

  def generate_down_left_diagonal_moves_from_a_position(n, node_num, array)
    (n...64).step(7) do |num|
      break if (num == node_num) && num % 8 == 0
      if num % 8 == 0
        array << num
        break
      end
      (num == node_num) ? next : array << num
    end
    array
  end

  context "#all_possible_moves" do
    it "total possible starting positions" do
      expect(queen.all_possible_moves.length).to eql(64)
    end

    context "returns the exact array of possible moves for each starting position" do
      (0..63).each do |n|
        it "position #{n}" do
          expect(queen.all_possible_moves[n].possible_moves).to match_array(possible_moves(n))
        end
      end
    end
  end
end