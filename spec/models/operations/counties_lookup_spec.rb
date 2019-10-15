require 'rails_helper'

RSpec.describe Operations::CountiesLookup, type: :model do
  let!(:countyzip) {FactoryBot.create(:locations_county_zip, county_name: 'Berkshire')}
  let!(:countyzip2) {FactoryBot.create(:locations_county_zip, county_name: 'Essex')}
  let!(:countyzip3) {FactoryBot.create(:locations_county_zip, zip: 10002)}

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  it 'should return a success of hash' do
    expect(subject.call(countyzip.zip).success.class).to eq(Hash)
  end

  it 'should return a success of hash with a specific key' do
    expect(subject.call(countyzip.zip).success).to have_key(:counties)
  end

  it 'should return counties with matching zipcode' do
    @counties = subject.call(countyzip.zip).success.values.first
    ['Essex', 'Berkshire'].each do |county|
      expect(@counties).to include(county)
    end
  end

  it 'should return sorted counties list' do
    expect(subject.call(countyzip.zip).success.values.first).to eq(['Berkshire', 'Essex'])
  end

  it 'should not return counties with non-matching zipcode' do
    expect(subject.call(countyzip.zip).success.values.first).not_to include(countyzip3.county_name)
  end

  it 'should not return unsorted counties list' do
    expect(subject.call(countyzip.zip).success.values.first).not_to eq(['Essex', 'Berkshire'])
  end
end
