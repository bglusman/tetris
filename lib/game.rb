require 'board'
require 'piece'
require 'bitmask'
class Game
  attr_reader :board, :time, :next_piece
  def initialize(initial_locked_pieces=0)
    @board = Board.new
    @time  = 0
    @next_piece = Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample))
    initial_locked_pieces.times do
      piece = Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample), position:[(rand*10).floor,17 + (rand*4).floor ])

      if board.legal_piece?(piece)
        board.add(piece)
        old_pos = piece.current_position
        5.times { board.move(0, 1, piece) }
        legal = board.legal_piece?(piece)
        puts "not legal #{piece.x},#{piece.y}" if !legal
        info "not legal  #{piece.x},#{piece.y}" if !legal && respond_to?(:info)
        redo unless legal
        piece.lock!
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
    when :left then board.move(-1,0)
    when :right then board.move(1,0)
    when :down then board.move(0,1) #or implement drop feature?
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
    old_pos = board.current_piece.current_position
    move(:down)
    board.current_piece.lock! if old_pos == board.current_piece.current_position
    unless board.current_piece
      board.add(next_piece)
      @next_piece = Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample))
    end

  end

  def initial_bitmasks
    #hardcoding starting bitmask coordinates
    {
      line:      [[2,1],[2,2],[2,3],[2,4]],
      block:     [[1,1],[1,2],[2,1],[2,2]],
      el_shape:  [[2,1],[2,2],[2,3],[3,3]],
      reverse_el:[[2,1],[2,2],[2,3],[3,1]],
      t_shape:   [[2,1],[1,2],[2,2],[3,2]],
      s_shape:   [[1,2],[2,2],[2,1],[3,1]],
      z_shape:   [[1,1],[2,1],[2,2],[3,2]],
    }
  end

end