require 'color'
require 'forwardable'
class Piece
  extend Forwardable
  ORIGIN_X = 2
  ORIGIN_Y = 2
  attr_reader :position, :color, :bitmask, :locked
  def_delegators :bitmask, :rotate, :unrotate

  def initialize(bitmask:, position: [5,0], locked: false, color: Color.new)
    @bitmask  = bitmask
    @locked   = locked
    @position = position
    @color    = color
  end

  def x
    position[0]
  end

  def y
    position[1]
  end

  def position=(new_position)
    @position = new_position unless locked?
  end

  def current_bitmask
    bitmask.dup
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
        yield [x,y] if bitmask.occupy?(x - position[0] + ORIGIN_X, y - position[1] + ORIGIN_Y) && Board.valid_x_y?(x,y)
      end
    end
  end

  def occupy?(x, y)
    mask_x = x - position[0] + ORIGIN_X
    mask_y = y - position[1] + ORIGIN_Y
    if !Board.valid_x_y?(x,y)
      true #shortcut to avoid testing out of bounds squares
    elsif Bitmask.valid_mask_x_y?(mask_x,mask_y)
      bitmask.occupy?(mask_x, mask_y)
    end
  end
end