require 'board'
require 'piece'
require 'bitmask'
# require 'forwardable'
class Game
  # extend Forwardable
  # def_delegators :board, :rotate, :unrotate
  attr_reader :board, :time
  def initialize(initial_locked_pieces=0)
    @board = Board.new
    @time  = 0
    initial_locked_pieces.times do
      piece = Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample), position:[(rand*10).floor,17 + (rand*4).floor ], locked:true)

      if board.legal_piece?(piece)
        board.add(piece)
        4.times { board.move(0, 1, piece) }
      else
        redo
      end
    end
    board.add(Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample)))
  end

  def board_pieces
    board.pieces
  end

  def move(direction)
    case direction
    when :left then board.move(x-1,y)
    when :right then board.move(x+1,y)
    when :down then board.move(x,y+1) #or implement drop feature?
    when :rotate then board.rotate
    end
  end

  def x
    board.current_piece.x
  end

  def y
    board.current_piece.y
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