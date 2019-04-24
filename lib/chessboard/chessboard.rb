# This is the class for the entire chessboard
# The @chessboard instance variable is the vertex list

$: << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'tile.rb'

class Chessboard
  attr_accessor :chessboard

  def initialize
    @chessboard = create_chessboard
  end

  def print_board
    (8).downto(0).each do |n|
      puts (n.zero?) ? "#{row_separator}\n#{column_letters}" : "#{row_separator}\n#{generate_row(n)}"
    end
  end

  private
  def create_row(row_num)
    row = []
    ("a".."h").each { |l| row << Tile.new([l, row_num], " ", []) }
    row
  end
  
  def create_chessboard
    chessboard = []
    (1..8).each { |n| chessboard += create_row(n) }
    chessboard
  end
  
  def row_start(num)
    (num - 1) * 8
  end
  
  def row_end(num)
    num * 8
  end
  
  def row_separator
    "   +---+---+---+---+---+---+---+---+"
  end
  
  def column_letters
    "     a   b   c   d   e   f   g   h"
  end

  def generate_row(n)
    row = " #{n} |"
    self.chessboard[row_start(n)...row_end(n)].each { |tile| row += " #{display_chess_pieces_or_spaces(tile)} |" }
    row
  end

  def display_chess_pieces_or_spaces(tile)
    if tile.piece == " "
      " "
    else
      "#{tile.piece.piece}"
    end
  end
end

           test = Chessboard.new
           test.print_board