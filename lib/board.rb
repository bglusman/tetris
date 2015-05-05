class Board

  attr_reader :pieces
  def initialize
    @pieces = []
    @grid = []
    (0..23).each {|index| @grid[index] = (1..10).map { nil } }
  end

  def display(all: false)
    @grid.each do |column|
      column.each do |row|
        yield [column, row]
      end
    end
  end

  # def pieces
  #   # require 'pry'; binding.pry
  #   @grid.flatten.map.select {|x| x.kind_of?(Piece)}
  # end

  def add(piece, position: [0,0])
    @pieces  += [piece]
  end

  def get(column, row)
    @pieces.find {|piece| piece.occupy?(column, row) }
  end
end
