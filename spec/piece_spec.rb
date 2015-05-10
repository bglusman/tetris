require 'spec_helper'
require_relative '../lib/piece'
require_relative '../lib/bitmask'
describe Piece do

  let(:piece)  { Piece.new(bitmask: Bitmask.new([[0,0]],1)) }

  it "knows its position" do
    expect(piece.position).to be_truthy
  end

  it "knows whether it is locked in position" do
    expect(piece.locked?).to be_falsy
  end

  it "allows locking into current position" do
    piece.lock!
    expect(piece.locked?).to be_truthy
  end

  it "allows setting position" do
    new_position = [3,4]
    piece.position = new_position
    expect(piece.position).to eq(new_position)
  end

  it "does not update position if locked" do
    new_position = [3,4]
    piece.lock!
    piece.position = new_position
    expect(piece.position).not_to eq(new_position)
  end

  it "has random color by default" do
    expect(piece.color).to respond_to(:hex)
  end

  it "allows assigning piece color" do
    color = Color.new
    expect(Piece.new(bitmask: 'fakeBitmask', color: color).color).to eq(color)
  end
end