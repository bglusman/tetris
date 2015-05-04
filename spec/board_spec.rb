require 'spec_helper'
require_relative '../lib/board'
describe Board do

  let(:board)  { Board.new }

  it "yields all squares in a board if passed all: true option" do
    board.display(all: true) { |sq| @x ||= 0; @x += 1 }
    expect(@x).to eq(10*24) #yielded once for each for and column
  end

  it 'allows adding a new piece to the board, and retains position of piece' do
    expect(board.get(5,5)).not_to eq(true)
    board.add(true, position: [5,5])
    expect(board.get(5,5)).to eq(true)
  end

end