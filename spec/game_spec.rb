require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/board'
describe Game do
  let(:starting_squares) { 5 }
  let(:game)  { Game.new }
  let(:seeded_game) { Game.new(starting_squares) }

  it 'ticks frames which move unlocked pieces' do
    old_position = game.board_pieces.first.position.dup
    game.tick
    expect(old_position).not_to eq(game.board_pieces.first.position)
  end

  it "allows starting random starting pieces at bottom" do
    expect(seeded_game.board.pieces.count).to eq(starting_squares + 1)
  end

  it "starts random locked pieces in legal positions within the board" do
    binding.pry
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

end