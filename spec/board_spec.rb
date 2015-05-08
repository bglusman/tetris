require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/piece'
describe Board do

  let(:board)  { Board.new }
  let(:block_mask) { [[[1,1],[1,2],[2,1],[1,1]],4] }
  let(:el_mask)    { [[[1,0],[1,1],[1,2],[2,2]],3] }

  it 'allows adding a new piece to the board, and retains position of piece' do
    expect(board.get(0,5)).to be_falsy
    piece = Piece.new(bitmask: Bitmask.new(*block_mask), position: [5,0], locked: true) #get only checks locked pieces now
    board.add(piece)
    expect(board.get(5,0)).to be_truthy
  end

  it 'only allows one unlocked piece at a time' do
    #because otherwise it's hard for it to drive piece movement correctly,
    #but just documeting here for now, unsure if worth testing/enforcing
  end

  describe 'controlling without collisions' do
    let(:locked_piece) { Piece.new(bitmask: Bitmask.new(*block_mask), position: [5,20], locked: true) }
    let(:loose_piece) { Piece.new(bitmask: Bitmask.new(*block_mask), position: [5,17]) }
    let(:blocked_piece) { Piece.new(bitmask: Bitmask.new(*block_mask), position: [5,18]) }
    let(:rotateable_piece) { Piece.new(bitmask: Bitmask.new(*el_mask), position: [4,17]) }
    let(:unrotateable_piece) { Piece.new(bitmask: Bitmask.new(*el_mask), position: [6,20]) }
    it 'allows movement if a move would not overlap another piece' do
      board.add(locked_piece)
      board.add(loose_piece)
      board.move(0,1)
      expect(loose_piece.position[1]).to eq(18)
    end

    it 'prevents movement if a move would overlap another piece' do
      board.add(locked_piece)
      board.add(blocked_piece)
      board.move(0,1)
      expect(blocked_piece.position[1]).to eq(18)
    end

    it 'allows rotation if would not overlap another piece' do
      board.add(locked_piece)
      board.add(rotateable_piece)
      old_bitmask = rotateable_piece.bitmask.dup
      board.rotate
      expect(rotateable_piece.bitmask).not_to eq(old_bitmask)
    end

    it 'prevents rotation if would overlap another piece' do
      board.add(locked_piece)
      board.add(unrotateable_piece)
      old_bitmask = unrotateable_piece.bitmask.dup
      board.rotate
      expect(unrotateable_piece.bitmask).to eq(old_bitmask)
    end

  end

end