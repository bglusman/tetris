require "opal"
require "react"
require "browser"
require "game"
require "jquery"

class Tetris
  include React::Component

  def render
    game = params[:game]
    columns = Board::X_DIMENSION
    rows    = Board::Y_DIMENSION - 1
    start_row = Board::Y_DIMENSION - Board::VISIBLE_Y_DIMENSION + 1
    div(id: 'main') do
      div(id: 'nextPiecePreview') do
        span {"Next Piece:" }
        0.upto(3) do |row|
          div(id: "preview-row-#{row}", className: 'row') do
            br(className: 'rowDivider')
            0.upto(3) do |column|
              piece = game.next_piece
              shape = piece.shape if piece.bitmask.occupy?(row, column)
              div(className: "gameSquare  #{shape}", data: ["row-num: #{row}", "col-num: #{col}"] )
            end
          end
        end
      end

      start_row.upto(rows) do |row|
        div(id: "row-#{row}", className: 'row') do
          br(className: 'rowDivider')
          columns.times do |column|
            piece = game.board.get(column, row)
            piece ||= game.board.current_piece.occupy?(column, row) ? game.board.current_piece : nil
            color, shape = piece.color, piece.shape if piece
            div(className: "gameSquare #{shape}", data: ["row-num: #{row}", "col-num: #{col}"] )
          end
        end
      end
    end
  end
end

React.expose_native_class(Tetris)

last = Time.now
seconds_per_tick = 0.4
start_pieces = 0
game = Game.new(start_pieces)

%x{
  $(document).on('keydown', function(event){
      switch (event.keyCode) {

        case 37: #{game.move(:left)}
          break;
        case 38: #{game.move(:unrotate)}
          break;
        case 39: #{game.move(:right)}
          break;
        case 40: #{game.move(:down)}
      }
    })

}

$window.every(0.05) do
  if Time.now - last > seconds_per_tick
    game.tick
    last = Time.now
  end

  container = `document.getElementById('container')`

  element = `<Tetris game={#{game}}/>`
  React.render element, container

end