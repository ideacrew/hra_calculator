require 'rails_helper'

RSpec.describe Validations::CountyZipFileContract, type: :model, dbclean: :after_each do

  context 'for success case' do
    before do
      @result = subject.call({ county_zip_file: 'spec/test_data/rating_areas/ma_county_zipcode.xlsx' })
    end

    it 'should be a container-ready operation' do
      expect(subject.respond_to?(:call)).to be_truthy
    end

    it 'should return Dry::Validation::Result object' do
      expect(@result).to be_a ::Dry::Validation::Result
    end

    it 'should not return any errors' do
      expect(@result.errors.to_h).to be_empty
    end
  end

  context 'for failure case' do
    before do
      @result = subject.call({ county_zip_file: 'county_zip_file.xml' })
    end

    it 'should return any errors' do
      expect(@result.errors.to_h).not_to be_empty
    end

    it 'should return any errors' do
      expect(@result.errors.to_h).to eq({ :county_zip_file=>["is not a file, please upload a file"] })
    end
  end
end
