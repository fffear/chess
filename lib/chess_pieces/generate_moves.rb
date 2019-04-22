$: << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'chessboard'

module GenerateMoves
  def generate_all_horizontal_moves(starting_positions)
    (0...64).each { |node_num| generate_horizontal_moves_from_a_position(node_num, starting_positions) }
  end

  def generate_all_vertical_moves(starting_positions)
    (0...64).each { |node_num| generate_vertical_moves_from_a_position(node_num, starting_positions) }
  end

  def generate_all_diagonal_moves
    generate_up_right_diagonal_moves
    generate_down_left_diagonal_moves
  end

  def generate_up_right_diagonal_moves
    (0...64).each do |node_num|
      n = node_num
      n -= 9 until n % 8 == 0 || n <= 8
      generate_up_right_diagonal_moves_from_a_position(n, node_num)
    end
  end

  def generate_down_left_diagonal_moves
    (0...64).each do |node_num|
      n = node_num
      n -= 7 until n % 8 == 7 || n <= 7
      generate_down_left_diagonal_moves_from_a_position(n, node_num)
    end
  end
  
  private
  def generate_vertical_moves_from_a_position(node_num, starting_positions)
    starting_column(node_num).step(8) { |num| (num == node_num) ? next : add_node(node_num, num) }
  end

  def generate_horizontal_moves_from_a_position(node_num, starting_positions)
    starting_row(node_num).each { |num| (num == node_num) ? next : add_node(node_num, num) }
  end

  def generate_down_left_diagonal_moves_from_a_position(n, node_num)
    (n...64).step(7) do |num|
      break if (num == node_num) && num % 8 == 0
      if num % 8 == 0
        add_node(node_num, num)
        break
      end
      (num == node_num) ? next : add_node(node_num, num)
    end
  end

  def generate_up_right_diagonal_moves_from_a_position(n, node_num)
    (n...64).step(9) do |num|
      break if (num == node_num) && num % 8 == 7
      if num % 8 == 7
        add_node(node_num, num)
        break
      end
      (num == node_num) ? next : add_node(node_num, num)
    end
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