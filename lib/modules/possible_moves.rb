module PossibleMoves
  def pawn_diagonal_move?(piece_location, king_position)
    [7, 9, -7, -9].one? { |n| king_position == piece_location + n }
  end

  def vertical_move?(piece_location, king_position)
    (king_position > piece_location && [8, 16, 24, 32, 40, 48, 56].one? { |n| king_position == piece_location + n }) ||
    (piece_location > king_position && [-8, -16, -24, -32, -40, -48, -56].one? { |n| king_position == piece_location + n })
  end

  def horizontal_move?(piece_location, king_position)
    (king_position > piece_location && (1..7 - (piece_location % 8)).one? { |n| king_position == piece_location + n }) ||
    (piece_location > king_position && (-(piece_location % 8)..-1).one? { |n| king_position == piece_location + n })
  end

  def diagonal_bot_left_to_top_right_move?(piece_location, king_position)
    (king_position > piece_location && [9, 18, 27, 36, 45, 54, 63].one? { |n| king_position == piece_location + n }) ||
    (piece_location > king_position && [-9, -18, -27, -36, -45, -54, -63].one? { |n| king_position == piece_location + n })
  end

  def diagonal_bot_right_to_top_left_move?(piece_location, king_position)
    #king_position > piece_location && piece_location % 8 > 0 && 
    #if piece_location % 7 == 0 && king_position >= piece_location + 7
    #  return false
    #end
    (king_position > piece_location && (7..7 * (piece_location % 8)).step(7).one? { |n| king_position == piece_location + n }) ||
    (piece_location > king_position && (-49 + 7 * (piece_location % 8)..-7).step(7).one? { |n| king_position == piece_location + n })

    #(king_position > piece_location && [7, 14, 21, 28, 35, 42, 49].one? { |n| king_position == piece_location + n }) ||
    #(piece_location > king_position && [-7, -14, -21, -28, -35, -42, -49].one? { |n| king_position == piece_location + n })
  end

  def blocked_upwards_and_to_the_right?(shift_factor, piece_location, king_position)
    piece_location < king_position && (piece_location + shift_factor..king_position - shift_factor).step(shift_factor).any? { |n| board.board[n].piece != " " }
  end

  def blocked_downwards_and_to_the_left?(shift_factor, piece_location, king_position)
    king_position < piece_location && (king_position + shift_factor..piece_location - shift_factor).step(shift_factor).any? { |n| board.board[n].piece != " " }
  end

  def path_blocked?(shift_factor, piece_location, king_position)
    blocked_upwards_and_to_the_right?(shift_factor, piece_location, king_position) || blocked_downwards_and_to_the_left?(shift_factor, piece_location, king_position)
  end
end