$: << "#{File.expand_path('../../chessboard', __FILE__)}"
$: << "#{File.expand_path('../../chess_pieces', __FILE__)}"
$: << "#{File.expand_path('../../move_pieces', __FILE__)}"

require 'chess_pieces'
require 'coordinates'

#require 'chessboard'
#require 'rook'
#require 'knight'
#require 'bishop'
#require 'queen'
#require 'king'
#require 'pawn'

class MovePawn
  include ChessPieces
  include Coordinates
  attr_accessor :board, :origin, :destination, :own_pieces, :turn_count, :opponent_pieces

  def initialize(origin, destination, board, own_pieces, opponent_pieces, turn_count)
    @origin = origin
    @destination = destination
    @board = board
    @own_pieces = own_pieces
    @turn_count = turn_count
    @opponent_pieces = opponent_pieces
  end

  def compute
    return if board.board[convert_coordinates_to_num(@origin)].piece == " "
    return puts "The coordinates entered are invalid." unless valid_coordinate?(@origin) && valid_coordinate?(@destination)
    @start = convert_coordinates_to_num(@origin)
    @final = convert_coordinates_to_num(@destination)
    return unless board.board[@start].piece.piece == @own_pieces[5]
    return puts "Can't move selected piece there." unless valid_move?
    return move_piece_vertically_if_no_blocking_pieces if valid_move? && vertical_move?
    return enpassant if enpassant_conditions?
    return move_piece_diagonally_if_no_blocking_pieces if valid_move? && diagonal_move?
    #puts turn_count
  end

  private
  def move_piece_vertically_if_no_blocking_pieces
    if path_blocked_vertically?(8) || destination_occupied_by_own_piece? || destination_occupied_by_opponent_piece?
      return puts "Can't move selected piece there."
    end
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@start].piece = " "
    @board.board[@final].piece.move_count += 1
    @board.board[@final].piece.time_first_move = @turn_count if @board.board[@final].piece.time_first_move == 0
    select_promotion if promotion_conditions_met?
  end

  def move_piece_diagonally_if_no_blocking_pieces
    if destination_occupied_by_opponent_piece?
      @board.board[@final].piece = board.board[@start].piece
      @board.board[@start].piece = " "
      @board.board[@final].piece.time_first_move = turn_count if @board.board[@final].piece.time_first_move == 0
      @board.board[@final].piece.move_count += 1
    else
      return puts "Can't move selected piece there."
    end
    select_promotion if promotion_conditions_met?
  end

  def enpassant
    @board.board[@final].piece = board.board[@start].piece
    @board.board[@final - 8].piece = " " if @final > @start
    @board.board[@final + 8].piece = " " if @start > @final
    @board.board[@start].piece = " "
  end

  def enpassant_conditions?
    enpassant_up? || enpassant_down?
  end

  def enpassant_up?
    @final > @start && @board.board[@final - 8].piece != " " && @board.board[@final - 8].piece.piece == opponent_pieces[5] && next_move?
  end

  def enpassant_down?
    @start > @final && @board.board[@final + 8].piece != " " && @board.board[@final + 8].piece.piece == opponent_pieces[5] && next_move?
  end

  def next_move?
    if @final > @start
      turn_count == board.board[@final - 8].piece.time_first_move + 1
    elsif @start > @final
      turn_count == board.board[@final + 8].piece.time_first_move + 1
    end
  end

  def select_promotion
    promotion = ensure_valid_promotion_selected
    promotion_options(promotion)
  end

  def ensure_valid_promotion_selected
    loop do
      puts "Please choose what to promote pawn to."
      puts "1: Rook\n2: Knight\n3: Bishop\n4: Queen"
      promotion = gets.chomp
      return promotion if promotion =~ /^[1234]$/
      puts "Invalid response, please select again" if promotion =~ /.|../
    end
  end

  def promotion_options(promotion)
    @board.board[@final].piece = Rook.new(own_pieces[0]) if promotion.to_i == 1
    @board.board[@final].piece = Knight.new(own_pieces[1]) if promotion.to_i == 2
    @board.board[@final].piece = Bishop.new(own_pieces[2]) if promotion.to_i == 3
    @board.board[@final].piece = Queen.new(own_pieces[3]) if promotion.to_i == 4
  end

  def promotion_conditions_met?
    @final >= 56 || @final <= 7
  end

  def path_blocked_vertically?(shift_factor)
    blocked_upwards?(shift_factor) || blocked_downwards?(shift_factor)
  end

  def blocked_upwards?(shift_factor)
    @start < @final && (@start + shift_factor..@final - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def blocked_downwards?(shift_factor)
    @final < @start && (@final + shift_factor..@start - shift_factor).step(shift_factor).one? { |n| board.board[n].piece != " " }
  end

  def own_piece?
    own_pieces.include?(board.board[@start].piece.piece)
  end

  def destination_occupied_by_own_piece?
    @board.board[@final].piece != " " && own_pieces.include?(board.board[@final].piece.piece)
  end

  def destination_occupied_by_opponent_piece?
    @board.board[@final].piece != " " && !own_pieces.include?(board.board[@final].piece.piece)
  end

  def valid_move?
    board.board[@start].piece.starting_positions[@start].possible_moves.include?(@final)
  end

  def vertical_move?
    [8, 16, -8, -16].one? { |n| @final == @start + n }
  end

  def diagonal_move?
    [7, 9, -7, -9].one? { |n| @final == @start + n }
  end

  def piece_moved?
    (board.board[@start].piece.move_count) != 0
  end
end