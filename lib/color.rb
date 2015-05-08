class Color
  COLOR_SPACE = 256
  attr_reader :red, :blue, :green
  def initialize(opts={red:nil,green:nil,blue:nil})
    @red    = opts[:red]  || (rand * COLOR_SPACE).floor
    @blue   = opts[:blue] || (rand * COLOR_SPACE).floor
    @green  = opts[:green]|| (rand * COLOR_SPACE).floor
  end

  def hex
    "0x%02x%02x%02x" % [red, green, blue]
  end
end