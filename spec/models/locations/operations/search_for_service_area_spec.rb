# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Locations::Operations::SearchForServiceArea, :dbclean => :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let(:tenant_params) do
    {key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email}
  end
  let(:value_for_age_rated) { 'age_rated' }
  let(:value_for_geo_rating_area) { 'zipcode' }
  include_context 'setup tenant'
  let!(:countyzip) { FactoryBot.create(:locations_county_zip) }
  let!(:search_areas) { FactoryBot.create(:locations_service_area, active_year: 2020, covered_states: [], county_zip_ids: [countyzip.id]) }

  describe 'tenant with age_rated and zipcode' do
    let(:hra_object) do
      ::HraAffordabilityDetermination.new({ tenant: :ma, state: 'Massachusetts', zipcode: countyzip.zip, county: countyzip.county_name,
                                            dob: Date.new(2000), household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
                                            start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly', hra_amount: 1000}
      )
    end

    context 'for success case' do
      before do
        @search_search_areas_result ||= subject.call(hra_object)
      end

      it 'should return success' do
        expect(@search_search_areas_result.success?).to be_truthy
      end

      it 'should return valid Service Area object ids' do
        search_areas_ids = @search_search_areas_result.success
        search_areas = ::Locations::ServiceArea.find(search_areas_ids.first)
        expect(search_areas).to be_truthy
      end
    end

    context 'for failure case' do
      before do
        hra_object.zipcode = 20001
        @search_search_areas_result ||= subject.call(hra_object)
      end

      it 'should return failure' do
        expect(@search_search_areas_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_search_areas_result.failure.errors).to eq(['Could Not find Service Areas for the given data'])
      end
    end
  end

  describe 'tenant with non_age_rated and county' do
    before do
      tenant.update_attributes!(key: :ny, owner_organization_name: 'NY Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'county')
      countyzip.update_attributes!(zip: nil, county_name: 'Albany', state: 'NY')
    end

    let(:hra_object) do
      ::HraAffordabilityDetermination.new({ tenant: :ny, state: 'New York', zipcode: nil, county: countyzip.county_name,
                                            dob: nil, household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
                                            start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly', hra_amount: 1000}
      )
    end

    context 'for success case' do
      before do
        @search_search_areas_result ||= subject.call(hra_object)
      end

      it 'should return success' do
        expect(@search_search_areas_result.success?).to be_truthy
      end

      it 'should return valid Service Area object ids' do
        search_areas_ids = @search_search_areas_result.success
        search_areas = ::Locations::ServiceArea.find(search_areas_ids.first)
        expect(search_areas).to be_truthy
      end
    end

    context 'for failure case' do
      before do
        hra_object.county = 'County'
        @search_search_areas_result ||= subject.call(hra_object)
      end

      it 'should return failure' do
        expect(@search_search_areas_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_search_areas_result.failure.errors).to eq(['Could Not find Service Areas for the given data'])
      end
    end
  end
end
