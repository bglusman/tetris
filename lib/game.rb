require 'board'
require 'piece'

class Game
  attr_reader :board, :time
  def initialize
    @board = Board.new
    @time  = 0
    board.add(Piece.new(bitmask:'fakeBitmask'))
  end

  def board_pieces
    board.pieces
  end

  def tick
    board_pieces.reject(&:locked?).map(&:descend)
  end

end