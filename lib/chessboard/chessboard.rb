# This is the class for the entire chessboard
# The @chessboard instance variable is the vertex list

$LOAD_PATH << "#{File.expand_path('../../chessboard', __FILE__)}"
require 'tile.rb'

class Chessboard
  attr_accessor :chessboard

  def initialize
    @chessboard = create_chessboard
  end

  private
  def create_row(row_num)
    row = []
    ("a".."h").each { |l| row << Tile.new([l, row_num], " ") }
    row
  end

  def create_chessboard
    chessboard = []
    (1..8).each { |n| chessboard += create_row(n) }
    chessboard
  end
end

# test = Chessboard.new
# p test.chessboard