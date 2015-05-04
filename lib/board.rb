class Board

  def initialize
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

  def pieces
    # require 'pry'; binding.pry
    @grid.flatten.map.select {|x| x.kind_of?(Piece)}
  end

  def add(piece, position: [0,0])
    @grid[position[0]][position[1]] = piece
  end

  def get(column, row)
    @grid[column][row]
  end
end
