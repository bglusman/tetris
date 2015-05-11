require 'board'
require 'piece'
require 'bitmask'
class Game
  attr_reader :board, :time, :next_piece
  def initialize(initial_locked_pieces=0, first_piece = nil)
    @board = Board.new
    @time  = 0
    @next_piece = Piece.new(bitmask: Bitmask.new(*random_bitmask))
    initial_locked_pieces.times do
      piece = Piece.new(bitmask: Bitmask.new(*random_bitmask), position:[(rand*10).floor,17 + (rand*4).floor ])

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
    first_piece ||= Piece.new(bitmask: Bitmask.new(*random_bitmask))
    board.add(first_piece)
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
      remove_complete_rows
      board.add(next_piece)
      @next_piece = Piece.new(bitmask: Bitmask.new(*random_bitmask))
    end

  end

  def remove_complete_rows
   full_row = (Board::Y_DIMENSION - 1).downto(3).find do |y|
      row_gap = (0...Board::X_DIMENSION).find {|x| !board.get(x,y)}
      # alert "ROW GAP in #{y}? : #{row_gap}"
      next if row_gap
      delete_row(y)
      y
    end
    remove_complete_rows if full_row
  end

  def delete_row(y_index)
    board.other_pieces.select do |piece|
      if piece.occupied_coordinates.any? {|(x,y)| y <= y_index }
        new_position = piece.current_position
        new_position[1] += 1
        piece.position!(new_position)
      end
    end
    self
  end

  def random_bitmask
    Piece.initial_bitmasks.values.sample
  end

end