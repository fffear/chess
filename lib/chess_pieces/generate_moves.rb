$LOAD_PATH << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'chessboard'

module GenerateMoves
  def generate_all_horizontal_moves(starting_positions)
    (0...64).each { |node_num| generate_horizontal_moves_from_a_position(node_num, starting_positions) }
  end

  def generate_all_vertical_moves(starting_positions)
    (0...64).each { |node_num| generate_vertical_moves_from_a_position(node_num, starting_positions) }
  end

  
  private
  def generate_vertical_moves_from_a_position(node_num, starting_positions)
    starting_column(node_num).step(8) { |num| (num == node_num) ? next : add_node(node_num, num) }
  end

  def generate_horizontal_moves_from_a_position(node_num, starting_positions)
    starting_row(node_num).each { |num| (num == node_num) ? next : add_node(node_num, num) }
  end
  
  def starting_column(node_num)
    (node_num % 8..63)
  end

  def starting_row(node_num)
    (node_num / 8 * 8..(node_num / 8 * 8) + 7)
  end

  def add_node(node_num, num)
    starting_positions[node_num].possible_moves << starting_positions[num].coordinates
  end
end