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
            piece ||= game.board.current_piece.occupy?(column, row) ? game.board.current_piece : nil
            color = piece.color if piece
            puts "piece: #{piece}, color: #{color}"
            color_string = color ? "rgb(#{color.red},#{color.green},#{color.blue})" : "white"
            div(className: 'gameSquare', data: ["row-num: #{row}", "col-num: #{col}"], style: {'backgroundColor' => color_string } ) do
              color ? "x" : " "
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
  puts "main loop now at #{Time.now}"
  if Time.now - last > seconds_per_tick
    puts "tick now x:#{game.board.current_piece.x}, x:#{game.board.current_piece.y}"
    game.tick
    last = Time.now
  end

  element = `<Tetris game={#{game}}/>`
  container = `document.getElementById('container')`
  React.render element, container
end