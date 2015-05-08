require "opal"
require "react"
require "browser"
require "game"

class Tetris
  include React::Component

  def render
    columns = Board::X_DIMENSION
    rows    = Board::Y_DIMENSION
    start_pieces = 0
    @game ||= Game.new(start_pieces)
    rows.times do |row|
      columns.times do |column|
        color = @game.board.get(column, row).try(:color)
        color_string = color ? "rgb(#{color.red},#{color.green},#{color.blue})" : "white"
        div(data: ["row-num: #{row}", "col-num: #{col}"], style: "background-color: #{color_string}" ) do
          color ? "x" : "_"
        end
      end
    end
  end
end

last = Time.now

$window.every(0.05) do
  seconds_per_tick = 0.5
  if Time.now - last > seconds_per_tick
    game.tick
    last = Time.now
  end

  element = `<Tetris />`
  container = `document.getElementById('container')`
  React.render element, container
end