require 'game'
BLOCK_WIDTH = 25
BLOCK_HEIGHT = 25
Shoes.app(title: 'Tetris',
          width: (Board::X_DIMENSION ) * BLOCK_WIDTH,
          height: (Board::Y_DIMENSION ) * BLOCK_HEIGHT) do
  start_pieces = 0
  seconds_per_tick = 0.5
  # game = Game.new(start_pieces)
  game = Game.new
  line1 = Piece.new(bitmask: Bitmask.new(*game.initial_bitmasks[:line]).rotate, position: [8,26], locked: true)
  line2 = Piece.new(bitmask: Bitmask.new(*game.initial_bitmasks[:line]).rotate, position: [4,26], locked: true)
  block = Piece.new(bitmask: Bitmask.new(*game.initial_bitmasks[:block]).rotate, position: [1,25], locked: true)

  game.board.add(line1); game.board.add(line2); game.board.add(block)

  game

  alert game.board.locked_squares.to_a.count.to_s
  keypress do |k|
    case k
    when :left, :right, :down  then game.move(k)
    when :up     then game.move(:rotate)
    when :escape then game = Game.new(start_pieces)
    end
  end

  def block(x, y, color)
    fill color
    rect(x*BLOCK_WIDTH, y*BLOCK_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT)
  end

  last = now = Time.now
  animate = animate 60 do
    if Time.now - last > seconds_per_tick
      game.tick
      last = Time.now
    end

    clear

    game.board.current_piece.occupied_coordinates do |x,y|
      block(x, y, game.board.current_piece.color.hex)
    end

    game.board.locked_squares do |x, y|
      piece = game.board.get(x,y)
      block(x, y, piece.color.hex)
    end
  end
end
