class Bitmask
  MASK_SIZE=5
  require 'matrix'

  def initialize(pairs)
    @matrix = (0...MASK_SIZE).map { (0...MASK_SIZE).map { nil } }
    pairs.each do |(x,y)|
      @matrix[x][y] = true
    end
  end

  def rotate
    @matrix = @matrix.transpose.map(&:reverse)
  end

  def unrotate
    @matrix = @matrix.transpose.reverse
  end

  def occupy?(x,y)
    @matrix[x][y]
  end
end