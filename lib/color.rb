class Color
  COLOR_SPACE = 256
  attr_reader :red, :blue, :green
  def initialize(red:nil,green:nil,blue:nil)
    @red    = red  || (rand * COLOR_SPACE).floor
    @blue   = blue || (rand * COLOR_SPACE).floor
    @green  = green|| (rand * COLOR_SPACE).floor
  end

  def hex
    "0x#{red.to_s(16)}#{green.to_s(16)}#{blue.to_s(16)}"
  end
end