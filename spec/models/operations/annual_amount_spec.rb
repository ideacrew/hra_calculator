require 'rails_helper'

RSpec.describe Operations::AnnualAmount, type: :model do
  let(:params) do
    {frequency: 'annually', amount: 1000.00}
  end

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  it 'should return the same amount as the frequency is annually' do
    expect(subject.call(params)).to eq(1000)
  end

  it 'should return the amount times 12 as the frequency is not annually' do
    expect(subject.call(params.merge!({frequency: 'monthly'}))).to eq(1000*12)
  end
end
