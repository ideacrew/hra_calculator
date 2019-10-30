require 'rails_helper'

RSpec.describe Locations::CountyZip, type: :model do
  let(:ma_countyzip) { FactoryBot.create(:locations_county_zip) }
  let(:ny_countyzip) { FactoryBot.create(:locations_county_zip, state: 'NY') }

  it 'should return MA' do
    expect(ma_countyzip.state).to eq('MA')
  end

  it 'should return NY' do
    expect(ny_countyzip.state).to eq('NY')
  end
end
