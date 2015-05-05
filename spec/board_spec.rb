require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/piece'
describe Board do

  let(:board)  { Board.new }

  it "yields all squares in a board if passed all: true option" do
    pending 'rethinking board role'
    board.display(all: true) { |sq| @x ||= 0; @x += 1 }
    expect(@x).to eq(10*24) #yielded once for each for and column
  end

  it 'allows adding a new piece to the board, and retains position of piece' do
    expect(board.get(0,5)).to be_falsy
    piece = Piece.new(bitmask: 'fake')
    board.add(piece, position: [5,5])
    expect(board.get(5,0)).to be_truthy
  end

end