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

  def generate_all_knight_moves
    (0..63).each do |n|
      generate_knight_left_moves(n)
      generate_knight_right_moves(n)
    end
  end


  
  private
  def generate_knight_left_moves(n)
    add_knight_node(n, 17) if n % 8 < 7 && starting_positions[n].coordinates[1] <= 6 # Up right moves (2 up 1 right)
    add_knight_node(n, 10) if n % 8 < 6 && starting_positions[n].coordinates[1] <= 7 # Up right moves (1 up 2 right)
    add_knight_node(n, -6) if n % 8 < 6 && starting_positions[n].coordinates[1] >= 2  # Down right moves (1 down 2 right)
    add_knight_node(n, -15) if n % 8 < 7 && starting_positions[n].coordinates[1] >= 3 # Down right moves (2 down 1 right)
  end

  def generate_knight_right_moves(n)
    add_knight_node(n, 15) if n % 8 > 0 && starting_positions[n].coordinates[1] <= 6 # Up left moves (2 up 1 left)
    add_knight_node(n, 6) if n % 8 > 1 && starting_positions[n].coordinates[1] <= 7 # Up left moves (1 up 2 left)
    add_knight_node(n, -10) if n % 8 > 1 && starting_positions[n].coordinates[1] >= 2  # Down left moves (1 down 2 left)
    add_knight_node(n, -17) if n % 8 > 0 && starting_positions[n].coordinates[1] >= 3  # Down left moves (2 down 1 left)
  end

  def add_knight_node(n, shift_factor)
    starting_positions[n].possible_moves << starting_positions[n + shift_factor].coordinates
  end

  def generate_vertical_moves_from_a_position(node_num, starting_positions)
    starting_column(node_num).step(8) { |num| (num == node_num) ? next : add_node(node_num, num) }
  end

  def generate_horizontal_moves_from_a_position(node_num, starting_positions)
    starting_row(node_num).each { |num| (num == node_num) ? next : add_node(node_num, num) }
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