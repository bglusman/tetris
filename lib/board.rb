class Board
  X_DIMENSION = 10
  Y_DIMENSION = 26
  attr_reader :pieces
  def initialize
    @pieces = []
  end

  def add(piece)
    pieces << piece
  end

  def get(x, y)
    other_pieces.find {|piece| piece.occupy?(x, y) }
  end

  def current_piece
    pieces.find(&:unlocked?)
  end

  def locked_squares
    return enum_for(:locked_squares) unless block_given?
    (0...X_DIMENSION).each do |x|
      (0...Y_DIMENSION).each do |y|
        yield [x,y] if get(x,y)
      end
    end
  end

  def self.valid_x_y?(x,y)
    x  < X_DIMENSION  && x >= 0 && y  < Y_DIMENSION  && y >= 0
  end

  def other_pieces(focus_piece = current_piece)
    pieces.reject {|piece| piece == focus_piece }
  end

  def move(x,y, piece = current_piece)
    if allowed_move?(x,y, piece) && piece.unlocked? &&
        legal_piece?(Piece.new(position: new_position(x,y, piece), bitmask: piece.current_bitmask ))
      piece.position = new_position(x,y, piece)
    end
  end

  def rotate(piece = current_piece)
    piece.rotate if allowed_rotate?
  end

  def unrotate(piece = current_piece)
    piece.unrotate if allowed_unrotate?
  end

  def new_position(x_diff,y_diff, piece = current_piece)
    [piece.x + x_diff, piece.y + y_diff]
  end

  def allowed_move?(x,y, piece = current_piece)
    legal_piece?(Piece.new(position: new_position(x,y, piece), bitmask: piece.bitmask))
  end

  def allowed_rotate?(piece = current_piece)
    legal_piece?(Piece.new(position: piece.position, bitmask: piece.current_bitmask.rotate ))
  end

  def allowed_unrotate?(piece = current_piece)
    legal_piece?(Piece.new(position: piece.position, bitmask: piece.current_bitmask.unrotate ))
  end

  def legal_piece?(piece)
    allowed = true
    piece.occupied_coordinates do |occ_x, occ_y|
      invalid = get(occ_x, occ_y) || !self.class.valid_x_y?(occ_x,occ_y) || !piece.legal_move?([occ_x, occ_y])
      next unless invalid
      allowed = false
    end
    allowed
  end

end
