require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/board'
describe Game do
  let(:starting_squares) { 5 }
  let(:block_mask) { [[[1,1],[1,2],[2,1],[2,2]],4] }
  let(:game)  { Game.new(0, Piece.new(bitmask: Bitmask.new(*block_mask))) }
  let(:seeded_game) { Game.new(starting_squares) }
  let(:complete_row_game) do
    game = Game.new
    line1 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:line]).rotate, position: [8,26], locked: true)
    line2 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:line]).rotate, position: [4,26], locked: true)
    block = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:block]).rotate, position: [1,25], locked: true)
    game.board.add(line1); game.board.add(line2); game.board.add(block)
    game
  end

  let(:two_rows_game) do
    game = Game.new
    block1 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:block]).rotate, position: [1,25], locked: true)
    block2 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:block]).rotate, position: [3,25], locked: true)
    block3 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:block]).rotate, position: [5,25], locked: true)
    block4 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:block]).rotate, position: [7,25], locked: true)
    block5 = Piece.new(bitmask: Bitmask.new(*Piece.initial_bitmasks[:block]).rotate, position: [9,25], locked: true)

    [block1 ,block2 ,block3 ,block4 ,block5].each {|blk| game.board.add(blk)}

    game
  end

  it 'ticks frames which move unlocked pieces' do
    old_position = game.board_pieces.first.position.dup
    game.tick
    expect(old_position).not_to eq(game.board_pieces.first.position)
  end

  it "allows starting random starting pieces at bottom" do
    expect(seeded_game.board.pieces.count).to eq(starting_squares + 1)
  end

  it "starts random locked pieces in legal positions within the board" do
    expect(seeded_game.board.locked_squares.to_a.count).to eq(4 * starting_squares)
  end

  it "moves random pieces to bottom of the board" do
    bottom_pieces = (0...Board::X_DIMENSION).map {|x| seeded_game.board.get(x, Board::Y_DIMENSION - 2) }.compact
    expect(bottom_pieces).not_to be_empty
  end

  it "fails to move piece when would move off board" do
    4.times { game.move(:right) }
    pos = game.board.current_piece.current_position
    game.move(:right)
    expect(game.board.current_piece.current_position).to eq(pos)
  end

  it "succeeds in moving piece when not off board" do
    initial_pos = game.board.current_piece.current_position
    3.times { game.move(:left) }
    expect(game.board.current_piece.current_position).not_to eq(initial_pos)
    pos = game.board.current_piece.current_position
    game.move(:left)
    expect(game.board.current_piece.current_position).not_to eq(pos)
  end

  it 'removes the number of squares in a row when deleting a row' do
    expect(complete_row_game.board.locked_squares.to_a.count).to eq(3 * 4) #3 pieces, 4 tiles each
    complete_row_game.remove_complete_rows
    expect(complete_row_game.board.locked_squares.to_a.count).to eq((3 * 4) - 10) #10 tiles in a row
  end

  it 'moves remaining squares down one row when deleting a row' do
    expect(complete_row_game.board.locked_squares.to_a).to include([0, 24])
    expect(complete_row_game.board.locked_squares.to_a).to include([1, 24])
    expect(complete_row_game.board.locked_squares.to_a).to include([0, 25])
    expect(complete_row_game.board.locked_squares.to_a).to include([1, 25])
    complete_row_game.remove_complete_rows
    expect(complete_row_game.board.locked_squares.to_a).to include([0, 25])
    expect(complete_row_game.board.locked_squares.to_a).to include([1, 25])
    expect(complete_row_game.board.locked_squares.to_a).not_to include([0, 26])
    expect(complete_row_game.board.locked_squares.to_a).not_to include([1, 26])
  end

  it 'removes two rows at once when both complete' do
    expect(two_rows_game.board.locked_squares.to_a.count).to eq(5 * 4) #5 pieces, 4 tiles each
    two_rows_game.remove_complete_rows
    expect(two_rows_game.board.locked_squares.to_a.count).to eq(0) #10 tiles in a row
  end

end