require "opal"
require "react"
require "browser"
require "game"

class Tetris
  include React::Component

  def render
    game = params[:game]
    columns = Board::X_DIMENSION
    rows    = Board::Y_DIMENSION
    div(id: 'main') do
      rows.times do |row|
        div(id: "row-#{row}", className: 'row') do
          br(className: 'rowDivider')
          columns.times do |column|
            piece = game.board.get(column, row)
            color = piece.color if piece
            color_string = color ? "rgb(#{color.red},#{color.green},#{color.blue})" : "white"
            div(className: 'game-square', data: ["row-num: #{row}", "col-num: #{column}"], style: {'backgroundColor' => color_string } ) do
              color ? "x" : "_"
            end
          end
        end
      end
    end
  end
end

React.expose_native_class(Tetris)

last = Time.now
seconds_per_tick = 0.5
start_pieces = 0
game = Game.new(start_pieces)

$window.every(0.05) do

  if Time.now - last > seconds_per_tick
    game.tick
    last = Time.now
  end

  element = `<Tetris game={#{game}}/>`
  container = `document.getElementById('container')`
  React.render element, container
end