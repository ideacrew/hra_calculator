# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Locations::Transactions::SearchForRatingArea, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let(:tenant_params) do
    { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
  end
  let(:value_for_age_rated) { 'age_rated' }
  let(:value_for_geo_rating_area) { 'zipcode' }
  include_context 'setup tenant'
  let!(:rating_area) { FactoryBot.create(:locations_rating_area, active_year: 2020) }
  let!(:countyzip) { ::Locations::CountyZip.find(rating_area.county_zip_ids.first) }

  describe 'tenant with age_rated and zipcode' do
    let(:params) do
      { tenant: :ma, state: 'Massachusetts', start_month: Date.new(2020), zipcode: countyzip.zip, county: countyzip.county_name }
    end

    context 'for success case' do
      before :each do
        @search_rating_area_result = subject.call(params)
      end

      it 'should return success' do
        expect(@search_rating_area_result.success?).to be_truthy
      end

      it 'should return a valid Rating Area object id' do
        rating_area_id = @search_rating_area_result.success
        rating_area = ::Locations::RatingArea.find(rating_area_id)
        expect(rating_area).to be_truthy
      end
    end

    context 'for failure case' do
      before :each do
        @search_rating_area_result ||= subject.call(params.merge!({ zipcode: 20001 }))
      end

      it 'should return failure' do
        expect(@search_rating_area_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_rating_area_result.failure).to eq(errors: ["Unable to find Rating Area for given data"])
      end
    end
  end

  describe 'tenant with non_age_rated and county' do
    before :each do
      tenant.update_attributes!(key: :ny, owner_organization_name: 'NY Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'county')
      countyzip.update_attributes!(zip: nil, county_name: 'Albany', state: 'NY' )
    end

    let(:params) do
      {tenant: :ny, state: 'New York', start_month: Date.new(2020), county: countyzip.county_name}
    end

    context 'for success case' do
      before :each do
        @search_rating_area_result ||= subject.call(params)
      end

      it 'should return success' do
        expect(@search_rating_area_result.success?).to be_truthy
      end

      it 'should return a valid Rating Area object id' do
        rating_area_id = @search_rating_area_result.success
        rating_area = ::Locations::RatingArea.find(rating_area_id)
        expect(rating_area).to be_truthy
      end
    end

    context 'for failure case' do
      before :each do
        @search_rating_area_result ||= subject.call(params.merge!({ county: 'County' }))
      end

      it 'should return failure' do
        expect(@search_rating_area_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_rating_area_result.failure).to eq(errors: ['Unable to find Rating Area for given data'])
      end
    end
  end

  describe 'tenant with age_rated and single' do
    before :each do
      tenant.update_attributes!(key: :dc, owner_organization_name: 'DC Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'single')
    end

    let(:params) do
      { tenant: :dc, state: 'District of Columbia', start_month: Date.new(2020) }
    end

    context 'for success case' do
      before :each do
        @search_rating_area_result ||= subject.call(params)
      end

      it 'should return success' do
        expect(@search_rating_area_result.success?).to be_truthy
      end

      it 'should not return any Rating Area object id' do
        expect(@search_rating_area_result.success).to be_nil
      end
    end
  end
end
