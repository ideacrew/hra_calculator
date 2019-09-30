require 'rails_helper'

RSpec.describe Operations::EncodeRgb, type: :model do

  it "should be a container-ready operation" do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context "Out of range values" do
    let(:over_range_value)  { 256 }
    let(:under_range_value) {  -1 }

    let(:over_range_colors)   { [over_range_value, over_range_value, over_range_value] }
    let(:under_range_colors)  { [under_range_value, under_range_value, under_range_value] }

    it "should restrict values within range" do
      expect(subject.call(over_range_colors).value!).to eq "ffffff"
      expect(subject.call(under_range_colors).value!).to eq "000000"
    end
  end

  context "Within range values" do
    let(:in_range_value)  { 255 }

    let(:in_range_colors) { [in_range_value, in_range_value, in_range_value] }

    it "it should set values to passed values" do
      expect(subject.call(in_range_colors).value!).to eq "ffffff"
    end
  end

end
