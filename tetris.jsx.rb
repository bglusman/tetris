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
            color_string = color ? "rgb(#{color.red},#{color.green},#{color.blue})" : "white"
            presence = color ? 'present' : 'absent'
            div(className: "gameSquare #{presence}", data: ["row-num: #{row}", "col-num: #{col}"], style: {'backgroundColor' => color_string } )
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


KEY_ENTER = 13

def handle_keydown(event)
  if Native(event).key_code == KEY_ENTER
    puts "hit enter"
  else
    puts "hit other key"
  end
end

puts 'setup native click'
Native(`window`).on(:key_down) { |e| puts "e:#{e}"; handle_keydown(e) }

$window.every(0.05) do
  if Time.now - last > seconds_per_tick
    game.tick
    last = Time.now
  end

  container = `document.getElementById('container')`

  element = `<Tetris game={#{game}}/>`
  React.render element, container

end