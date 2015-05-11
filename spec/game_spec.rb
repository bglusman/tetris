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
    line1 = Piece.new(bitmask: Bitmask.new(*game.initial_bitmasks[:line]).rotate, position: [8,26], locked: true)
    line2 = Piece.new(bitmask: Bitmask.new(*game.initial_bitmasks[:line]).rotate, position: [4,26], locked: true)
    block = Piece.new(bitmask: Bitmask.new(*game.initial_bitmasks[:block]).rotate, position: [1,25], locked: true)
    game.board.add(line1); game.board.add(line2); game.board.add(block)
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

  it 'deletes a row when the row is complete' do
    expect(complete_row_game.remove_complete_rows).not_to be_empty
  end

  it 'removes the number of squares in a row when deleting a row' do
    expect(complete_row_game.board.locked_squares.to_a.count).to eq(3 * 4) #3 pieces, 4 tiles each
    complete_row_game.remove_complete_rows
    expect(complete_row_game.board.locked_squares.to_a.count).to eq((3 * 4) - 10) #10 tiles in a row
  end

  it 'moves remaining squares down one row when deleting a row' do
    complete_row_game.remove_complete_rows
    expect(complete_row_game.board.get(0,26)).to be_truthy
    expect(complete_row_game.board.get(1,26)).to be_truthy
    expect(complete_row_game.board.get(0,25)).to be_falsy
    expect(complete_row_game.board.get(1,25)).to be_falsy
  end

end