require 'game'
if RUBY_PLATFORM == 'opal'
  nil
else
  require 'shoes'
  BLOCK_WIDTH = 25
  BLOCK_HEIGHT = 25
  Shoes.app(title: 'Tetris',
            width: Board::X_DIMENSION * BLOCK_WIDTH,
            height: Board::Y_DIMENSION * BLOCK_HEIGHT) do
    game = Game.new(8)

    keypress do |k|
      case k
      when :left, :right, :down  then game.move(k)
      when :up     then game.move(:rotate)
      when :escape then quit
      #when :space  then alert('add piece');game.board.add(Piece.new(bitmask: Bitmask.new(initial_bitmasks.values.sample)))
      end
    end

    def block(x, y, color)
      fill color
      rect(x*BLOCK_WIDTH, y*BLOCK_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
    end

    last = now = Time.now
    animate = animate 3 do
      # now = Time.now

      game.tick

      clear

      game.board.locked_squares do |x, y|
        piece = game.board.get(x,y)
        block(x, y, piece.color.hex)
      end

      game.board.current_piece.occupied_coordinates do |x,y|
        piece = game.board.get(x,y)
        block(x, y, piece.color.hex)
      end
    end
  end

end