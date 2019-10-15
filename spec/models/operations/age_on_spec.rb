require 'rails_helper'

RSpec.describe Operations::AgeOn, type: :model do
  let(:params) do
    {start_month: Date.new(2020, 10, 19), dob: Date.new(2000, 10, 18)}
  end

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  it 'should return integer with given params' do
    expect(subject.call(params).success).to eq(20)
  end

  it 'should return floored value even with the age is just less than the next possible integer' do
    expect(subject.call(params.merge!({start_month: Date.new(2020, 12, 31)})).success).to eq(20)
  end
end
