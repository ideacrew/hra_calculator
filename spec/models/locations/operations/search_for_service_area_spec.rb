require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Locations::Operations::SearchForServiceArea, :dbclean => :after_each do
  before do
    DatabaseCleaner.clean
  end

  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let(:tenant_params) do
    {key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email}
  end
  include_context 'setup tenant'
  let!(:countyzip) {FactoryBot.create(:locations_county_zip)}
  let!(:search_areas) {FactoryBot.create(:locations_service_area, active_year: 2020, covered_states: [], county_zip_ids: [countyzip.id])}

  describe 'tenant with age_rated and zipcode' do
    let(:params) do
      {tenant: :ma, state: 'Massachusetts', start_month: Date.new(2020), zipcode: countyzip.zip, county: countyzip.county_name}
    end

    before :each do
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'zipcode')
    end

    context 'for success case' do
      before :each do
        @search_search_areas_result ||= subject.call(params)
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
      before :each do
        @search_search_areas_result ||= subject.call(params.merge!({zipcode: 20001}))
      end

      it 'should return failure' do
        expect(@search_search_areas_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_search_areas_result.failure).to eq({:errors=>["Could Not find Service Areas for the given data"]})
      end
    end
  end

  describe 'tenant with age_rated and county' do
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
        @search_search_areas_result ||= subject.call(params)
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
      before :each do
        @search_search_areas_result ||= subject.call(params.merge!({county: 'County'}))
      end

      it 'should return failure' do
        expect(@search_search_areas_result.failure?).to be_truthy
      end

      it 'should return errors' do
        expect(@search_search_areas_result.failure).to eq({:errors=>["Could Not find Service Areas for the given data"]})
      end
    end
  end

  describe 'tenant with age_rated and county' do
    before :each do
      tenant.update_attributes!(key: :dc, owner_organization_name: 'DC Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'single')
    end

    let(:params) do
      {tenant: :dc, state: 'District of Columbia', start_month: Date.new(2020)}
    end

    context 'for success case' do
      before :each do
        @search_search_areas_result ||= subject.call(params)
      end

      it 'should return success' do
        expect(@search_search_areas_result.success?).to be_truthy
      end

      it 'should not return any Service Area object ids' do
        expect(@search_search_areas_result.success).to be_empty
      end
    end
  end

  after :all do
    DatabaseCleaner.clean
  end
end
