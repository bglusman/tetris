require 'color'
require 'forwardable'
class Piece
  extend Forwardable
  ORIGIN_X = 2
  ORIGIN_Y = 2
  attr_reader :position, :color, :bitmask, :locked
  def_delegators :bitmask, :rotate, :unrotate

  def initialize(bitmask:, position: [0,5], locked: false, color: Color.new)
    @bitmask  = bitmask
    @locked   = locked
    @position = position
    @color    = color
  end

  def position=(new_position)
    @position = new_position unless locked?
  end


  def unlocked?
    !locked?
  end

  def lock
    @locked = true
  end
  alias_method  :lock!, :lock
  alias_method  :locked?, :locked

  def descend
    @position[1] += 1 unless locked?
  end

  def occupied_coordinates
    return enum_for(:occupied_coordinates) unless block_given?
    ((position[0] - 2)...(position[0] + 2)).each do |x|
      ((position[1] - 2)...(position[1] + 2)).each do |y|
        yield [x,y] if occupy?(x,y)
      end
    end
  end

  def occupy?(x, y)
    if (position[0] - x).abs < Bitmask::MASK_SIZE && (position[1] - y).abs < Bitmask::MASK_SIZE
      bitmask.occupy?(x - position[0] + ORIGIN_X, y - position[1] + ORIGIN_Y)
    end
  end
end