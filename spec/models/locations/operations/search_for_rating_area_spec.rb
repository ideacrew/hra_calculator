# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Locations::Operations::SearchForRatingArea, dbclean: :after_each do
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
    let(:hra_object) do
      ::HraAffordabilityDetermination.new({ tenant: :ma, state: 'Massachusetts', zipcode: countyzip.zip, county: countyzip.county_name,
                                            dob: Date.new(2000), household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
                                            start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly', hra_amount: 1000}
      )
    end

    context 'for success case' do
      before do
        @search_rating_area_result = subject.call(hra_object)
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
      before do
        hra_object.zipcode = 20001
        @search_rating_area_result ||= subject.call(hra_object)
      end

      it 'should return failure' do
        expect(@search_rating_area_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_rating_area_result.failure.errors).to eq(["Could Not find Rating Area for the given data"])
      end
    end
  end

  describe 'tenant with non_age_rated and county' do
    before do
      tenant.update_attributes!(key: :ny, owner_organization_name: 'NY Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'county')
      countyzip.update_attributes!(zip: nil, county_name: 'Albany', state: 'NY' )
    end

    let(:hra_object) do
      ::HraAffordabilityDetermination.new({ tenant: :ny, state: 'NY', zipcode: nil, county: 'Albany',
                                            dob: nil, household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
                                            start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly', hra_amount: 1000}
      )
    end

    context 'for success case' do
      before do
        @search_rating_area_result ||= subject.call(hra_object)
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
      before do
        hra_object.county = 'County'
        @search_rating_area_result ||= subject.call(hra_object)
      end

      it 'should return failure' do
        expect(@search_rating_area_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_rating_area_result.failure.errors).to eq(["Could Not find Rating Area for the given data"])
      end
    end
  end
end
