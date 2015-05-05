class Board

  attr_reader :pieces
  def initialize
    @pieces = []
  end

  def add(piece, position: [4,0])
    @pieces  += [piece]
  end

  def get(column, row)
    @pieces.find {|piece| piece.occupy?(column, row) }
  end
end
