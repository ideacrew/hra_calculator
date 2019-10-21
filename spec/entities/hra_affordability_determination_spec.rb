require 'rails_helper'

RSpec.describe HraAffordabilityDetermination, dbclean: :after_each do
  describe 'with valid arguments' do
    let(:params) do
      { tenant: :ma, state: 'Massachusetts', zipcode: 'zip', county: 'county',
        dob: Date.new(2000), household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
        start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly', hra_amount: 1000}
    end

    it 'should initialize' do
      expect(HraAffordabilityDetermination.new(params)).to be_a HraAffordabilityDetermination
    end

    it 'should not raise error' do
      expect { HraAffordabilityDetermination.new(params) }.not_to raise_error
    end
  end

  describe 'with invalid arguments' do
    it 'should raise error' do
      expect { subject }.to raise_error(Dry::Struct::Error, /:tenant is missing in Hash input/)
    end
  end
end
