require 'rails_helper'

RSpec.describe Operations::AgeOn, type: :model do
  let(:hra_object) do
    ::HraAffordabilityDetermination.new({ tenant: :ma, state: 'Massachusetts', zipcode: 'zip', county: 'county_name',
                                          dob: Date.new(2000, 10, 18), household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
                                          start_month: Date.new(2020, 10, 19), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly', hra_amount: 1000}
    )
  end

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  it 'should return integer with given hra_object' do
    expect(subject.call(hra_object).success).to eq(20)
  end

  it 'should return floored value even with the age is just less than the next possible integer' do
    hra_object.start_month = Date.new(2020, 12, 31)
    expect(subject.call(hra_object).success).to eq(20)
  end
end
