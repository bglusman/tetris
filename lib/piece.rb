require 'color'
class Piece
  attr_reader :position, :color
  def initialize(bitmask:, position: [0,5], locked: false, color: Color.new)
    @bitmask  = bitmask
    @locked   = locked
    @position = position
    @color    = color
  end

  def position=(new_position)
    @position = new_position unless locked?
  end

  def locked?
    @locked
  end

  def lock
    @locked = true
  end
  alias_method  :lock!, :lock

  def position
    @position
  end
end