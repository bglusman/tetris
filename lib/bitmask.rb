class Bitmask
  OutOfBoundsError = Class.new(StandardError)
  attr_reader :matrix, :mask_size
  def initialize(pairs, mask_size=4)
    # binding.pry if mask_size == 3
    @matrix = (0...mask_size).map { (0...mask_size).map { nil } }
    @mask_size = mask_size
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

  def self.valid_mask_x_y?(x,y, mask_size)
    x < mask_size && y < mask_size && x >= 0 && y >= 0
  end

  def occupy?(x,y)
    # raise OutOfBoundsError if !self.class.valid_mask_x_y?(x,y, mask_size)
    @matrix[x][y]
  rescue NoMethodError
    false
  end

  def ==(other)
    matrix == other.matrix
  end
end