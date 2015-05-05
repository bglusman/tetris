class Bitmask
  MASK_SIZE=5
  OutOfBoundsError = Class.new(StandardError)
  require 'matrix'
  attr_reader :matrix
  def initialize(pairs)
    @matrix = (0...MASK_SIZE).map { (0...MASK_SIZE).map { nil } }
    pairs.each do |(x,y)|
      @matrix[x][y] = true
    end
  end

  def rotate
    @matrix = @matrix.transpose.map(&:reverse)
    self
  end

  def unrotate
    @matrix = @matrix.transpose.reverse
    self
  end

  def occupy?(x,y)
    raise OutOfBoundsError if x >= MASK_SIZE || y >= MASK_SIZE
    @matrix[x][y]
  end

  def ==(other)
    matrix == other.matrix
  end
end