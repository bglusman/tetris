class Board

  attr_reader :pieces
  def initialize
    @pieces = []
  end

  def add(piece, position: [4,0])
    pieces << piece
  end

  def get(column, row)
    other_pieces.find {|piece| piece.occupy?(column, row) }
  end

  def current_piece
    pieces.find(&:unlocked?)
  end

  def other_pieces
    pieces.reject {|piece| piece == current_piece }
  end

  def move(x,y)
    current_piece.position = new_position(x,y) if allowed_move?(x,y)
  end

  def rotate
    current_piece.rotate if allowed_rotate?
  end

  def unrotate
    current_piece.unrotate if allowed_unrotate?
  end

  def new_position(x,y)
    position = current_piece.position.dup
    position[0] += x
    position[1] += y
    position
  end

  def allowed_move?(x,y)
    legal_piece?(Piece.new(position: new_position(x,y), bitmask: current_piece.bitmask))
  end

  def allowed_rotate?
    new_piece = Piece.new(position: current_piece.position, bitmask: current_piece.bitmask.dup.rotate )
    # require 'pry'; binding.pry
    legal_piece?(new_piece)
  end

  def allowed_unrotate?
    legal_piece?(Piece.new(position: current_piece.position, bitmask: current_piece.bitmask.dup.unrotate ))
  end

  def legal_piece?(piece)
    allowed = true
    piece.occupied_coordinates do |occ_x, occ_y|
      next unless get(occ_x, occ_y)
      allowed = false
    end
    allowed
  end

end
