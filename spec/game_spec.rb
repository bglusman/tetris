require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/board'
describe Game do
  let(:game)  { Game.new }

  it 'ticks frames which move unlocked pieces' do
    old_position = game.board_pieces.first.position.dup
    game.tick
    expect(old_position).not_to eq(game.board_pieces.first.position)
  end

end