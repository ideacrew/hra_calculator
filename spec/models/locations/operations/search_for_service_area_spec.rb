require 'rails_helper'

describe ::Locations::Operations::SearchForServiceArea, :dbclean => :after_each do
  before do
    DatabaseCleaner.clean
    enterprise = Enterprises::Enterprise.new(owner_organization_name: 'OpenHBX')
    enterprise_option = Options::Option.new(key: 'owner_organization_name', default: 'My Organization', description: 'Name of the organization that manages', type: 'string')
    enterprise.options = [enterprise_option]
    enterprise.save!
    @enterprise = enterprise
    ResourceRegistry::AppSettings[:options].each do |option_hash|
      if option_hash[:key] == :benefit_years
        option = Options::Option.new(option_hash)

        option.child_options.each do |setting|
          enterprise.benefit_years.create({ expected_contribution: setting.default, calendar_year: setting.key.to_s.to_i, description: setting.description })
        end
      end
    end
    owner_account = Account.new(email: 'admin@openhbx.org', role: 'Enterprise Owner', uid: 'admin@openhbx.org', password: 'ChangeMe!', enterprise_id: enterprise.id)
    owner_account.save!
  end

  let!(:tenant_account) do
    account = Account.new(email: 'admin@market_place.org', role: 'Marketplace Owner', uid: 'admin@market_place.org', password: 'ChangeMe!', enterprise_id: @enterprise.id)
    account.save!
    account
  end

  let!(:tenant) do
    tenant_params = {key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email}
    create_tenant = ::Transactions::CreateTenant.new
    result = create_tenant.with_step_args(fetch: [enterprise: @enterprise]).call(tenant_params)
    result.success
  end

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
