require 'board'
require 'piece'
require 'bitmask'

class Game
  attr_reader :board, :time
  def initialize
    @board = Board.new
    @time  = 0
    board.add(Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample)))
  end

  def board_pieces
    board.pieces
  end

  def tick
    board_pieces.reject(&:locked?).map(&:descend)
  end

  def initial_bitmasks
    #hardcoding starting bitmask coordinates
    {
      line:      [[2,0],[2,1],[2,2],[2,3]],
      block:     [[2,2],[2,3],[3,2],[3,3]],
      el_shape:  [[2,1],[2,2],[2,3],[3,3]],
      reverse_el:[[2,1],[2,2],[2,3],[3,1]],
      t_shape:   [[2,1],[1,2],[2,2],[3,2]],
      s_shape:   [[1,2],[2,2],[2,1],[3,1]],
      z_shape:   [[1,1],[2,1],[2,2],[3,2]],
    }
  end

end