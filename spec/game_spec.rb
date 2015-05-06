require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/board'
describe Game do
  let(:game)  { Game.new }
  let(:game2) { Game.new(8) }

  it 'ticks frames which move unlocked pieces' do
    old_position = game.board_pieces.first.position.dup
    game.tick
    expect(old_position).not_to eq(game.board_pieces.first.position)
  end

  it "allows starting random starting pieces at bottom" do
    expect(game2.board.pieces.count).to eq(9) #8 above plus starting drop piece
  end

  it "starts random locked pieces in legal positions within the board" do
    expect(game2.board.locked_squares.to_a.count).to eq(4 * 8)
  end

  it "moves random pieces to bottom of the board" do
    bottom_pieces = (0...Board::X_DIMENSION).map {|x| game2.board.get(x, Board::Y_DIMENSION - 1) }.compact
    expect(bottom_pieces).not_to be_empty
  end

end