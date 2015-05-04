require 'pry'
class Board

  def initialize
    @grid = []
    (0..23).each {|index| @grid[index] = (1..10).map { nil } }
  end

  def display(opts={all: false})
    @grid.each do |column|
      column.each do |row|
        yield [column, row]
      end
    end
  end
end
