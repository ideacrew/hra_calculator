# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Transactions::CountyZipFile, type: :model, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }

  describe 'tenant with age_rated and zipcode as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'zipcode' }
    include_context 'setup tenant'

    context 'for success case' do
      let(:params) do
        { file: 'spec/test_data/rating_areas/ma_county_zipcode.xlsx', tenant: tenant, year: 2020, import_timestamp: DateTime.now }
      end

      before do
        @result = subject.call(params)
      end

      it 'return Dry Result Success object' do
        expect(@result).to be_a Dry::Monads::Result::Success
      end

      it 'should return a success message' do
        expect(@result.success).to eq('Successfully created 14 CountyZip and 7 RatingArea records')
      end
    end

    context 'for failure case' do
      let(:params) do
        { file: 'rating_area.xlsx', tenant: tenant, year: 2020, import_timestamp: DateTime.now }
      end

      before do
        @result = subject.call(params)
      end

      it 'return Dry Result Failure object' do
        expect(@result).to be_a Dry::Monads::Result::Failure
      end

      it 'should return a success message' do
        expect(@result.failure).to eq({errors: ['Unable to create data from file rating_area.xlsx']})
      end
    end
  end

  describe 'tenant with non_age_rated and county as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :ny, owner_organization_name: 'NY Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'non_age_rated' }
    let(:value_for_geo_rating_area) { 'county' }
    include_context 'setup tenant'

    context 'for success case' do
      let(:params) do
        { file: 'spec/test_data/rating_areas/ny_county_zipcode.xlsx', tenant: tenant, year: 2020, import_timestamp: DateTime.now }
      end

      before do
        @result = subject.call(params)
      end

      it 'return Dry Result Success object' do
        expect(@result).to be_a Dry::Monads::Result::Success
      end

      it 'should return a success message' do
        expect(@result.success).to eq('Successfully created 11 CountyZip and 8 RatingArea records')
      end
    end

    context 'for failure case' do
      let(:params) do
        { file: 'rating_area.xlsx', tenant: tenant, year: 2020, import_timestamp: DateTime.now }
      end

      before do
        @result = subject.call(params)
      end

      it 'return Dry Result Failure object' do
        expect(@result).to be_a Dry::Monads::Result::Failure
      end

      it 'should return a success message' do
        expect(@result.failure).to eq({errors: ['Unable to create data from file rating_area.xlsx']})
      end
    end
  end

  describe 'tenant with age_rated and single as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :dc, owner_organization_name: 'DC Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'single' }
    include_context 'setup tenant'

    context 'for success case' do
      let(:params) do
        { tenant: tenant }
      end

      before do
        @result = subject.call(params)
      end

      it 'return Dry Result Success object' do
        expect(@result).to be_a Dry::Monads::Result::Success
      end

      it 'should return a success message' do
        expect(@result.success).to eq('CountyZips not needed')
      end
    end
  end
end
