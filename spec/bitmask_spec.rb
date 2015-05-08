require 'spec_helper'
require 'bitmask'
describe Bitmask do

  let(:bitmask)  { Bitmask.new([[0,0]]) }

  it "tracks rotation moving a single active corner clockwise around mask corners" do
    pending
    expect(bitmask.occupy?(0,0)).to be_truthy
    expect(bitmask.occupy?(0,Bitmask::MASK_SIZE-1)).to be_falsy
    bitmask.rotate
    expect(bitmask.occupy?(0,0)).to be_falsy
    expect(bitmask.occupy?(0,Bitmask::MASK_SIZE-1)).to be_truthy
  end

  it "allows reversing rotation moving a single corner counter-clockwise" do
    pending
    expect(bitmask.occupy?(0,0)).to be_truthy
    expect(bitmask.occupy?(Bitmask::MASK_SIZE-1,0)).to be_falsy
    bitmask.unrotate
    expect(bitmask.occupy?(0,0)).to be_falsy
    expect(bitmask.occupy?(Bitmask::MASK_SIZE-1,0)).to be_truthy
  end

end