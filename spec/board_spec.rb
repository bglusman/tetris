require 'spec_helper'
require_relative '../board'
describe Board do
  it "yields all squares in a board if passed all: true option" do
    board = Board.new
    board.display(all: true) { |sq| @x ||= 0; @x += 1 }
    expect(@x).to eq(10*24) #yielded once for each for and column
  end
end