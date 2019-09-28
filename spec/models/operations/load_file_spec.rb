require 'rails_helper'

RSpec.describe Operations::LoadFile, type: :model do

  subject { described_class.new.call(input) }

  context 'When valid input hash passed' do
    let(:input) { __FILE__ } # use the current file for test

    it "should return success with file io" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to be_present
    end
  end
end
