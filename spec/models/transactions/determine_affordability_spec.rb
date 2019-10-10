require 'rails_helper'

describe ::Transactions::DetermineAffordability, :dbclean => :after_each do

  before do
    DatabaseCleaner.clean
    # TODO: move below code to factories, refactor needed
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

  describe 'tenant with age_rated and zipcode' do
    let(:tenant) do
      tenant_params = {key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email}
      create_tenant = ::Transactions::CreateTenant.new
      result = create_tenant.with_step_args(fetch: [enterprise: @enterprise]).call(tenant_params)
      result.success
    end

    let!(:product1) {
      product = FactoryBot.create(:products_health_product, tenant: tenant, application_period: Date.new(2020, 1, 1)..Date.new(2020, 12, 31))
      product.service_area.update_attributes!(active_year: 2020) if product.service_area
      product.premium_tables.each { |pt| pt.rating_area.update_attributes!(active_year: 2020) if pt.rating_area }
      product
    }

    let(:countyzip) { ::Locations::CountyZip.find(product1.premium_tables.first.rating_area.county_zip_ids.first.to_s) }

    let(:valid_params) do
      {
        tenant: :ma, state: 'Massachusetts', dob: '2000-10-10', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100, zipcode: countyzip.zip, county: countyzip.county_name
      }
    end

    before :each do
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'zipcode')
    end

    context 'with valid data' do
      context 'affordable' do
        before :each do
          @determined_result ||= subject.call(valid_params.merge!(household_amount: 1000000))
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return affordable per given data' do
            expect(@result[:hra_determination]).to eq(:affordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end

      context 'unaffordable' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result[:hra_determination]).to eq(:unaffordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: ''
        }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect{@determined_result.failure.to_json}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = @determined_result.failure
        end

        it 'should return a value of class Hash' do
          expect(@result.class).to eq(::Hash)
        end

        it 'should have any errors for given data' do
          expect(@result[:errors]).not_to be_empty
        end
      end
    end
  end

  describe 'tenant with non_age_rated and county' do
    let(:tenant) do
      tenant_params = {key: :ny, owner_organization_name: 'NY Marketplace', account_email: tenant_account.email}
      create_tenant = ::Transactions::CreateTenant.new
      result = create_tenant.with_step_args(fetch: [enterprise: @enterprise]).call(tenant_params)
      result.success
    end

    let!(:product1) {
      product = FactoryBot.create(:products_health_product, tenant: tenant, application_period: Date.new(2020, 1, 1)..Date.new(2020, 12, 31))
      product.service_area.update_attributes!(active_year: 2020, covered_states: ['NY']) if product.service_area
      product.premium_tables.each { |pt| pt.rating_area.update_attributes!(active_year: 2020) if pt.rating_area }
      product
    }

    let(:countyzip) { 
      county_zip = ::Locations::CountyZip.find(product1.premium_tables.first.rating_area.county_zip_ids.first.to_s)
      county_zip.update_attributes!(state: 'NY', county_name: 'New York')
      county_zip
    }

    let(:valid_params) do
      {
        tenant: :ny, state: 'New York', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100, county: countyzip.county_name
      }
    end

    before :each do
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'non_age_rated')
      options.second.update_attributes!(value: 'county')
    end

    context 'with valid data' do
      context 'affordable' do
        before :each do
          @determined_result ||= subject.call(valid_params.merge!(household_amount: 1000000))
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return affordable per given data' do
            expect(@result[:hra_determination]).to eq(:affordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end

      context 'unaffordable' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result[:hra_determination]).to eq(:unaffordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: ''
        }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect{@determined_result.failure.to_json}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = @determined_result.failure
        end

        it 'should return a value of class Hash' do
          expect(@result.class).to eq(::Hash)
        end

        it 'should have any errors for given data' do
          expect(@result[:errors]).not_to be_empty
        end
      end
    end
  end

  describe 'tenant with non_age_rated and county' do
    let(:tenant) do
      tenant_params = {key: :dc, owner_organization_name: 'DC Marketplace', account_email: tenant_account.email}
      create_tenant = ::Transactions::CreateTenant.new
      result = create_tenant.with_step_args(fetch: [enterprise: @enterprise]).call(tenant_params)
      result.success
    end

    let!(:product1) {
      product = FactoryBot.create(:products_health_product, tenant: tenant, application_period: Date.new(2020, 1, 1)..Date.new(2020, 12, 31), service_area_id: nil)
      product.premium_tables.each { |pt| pt.update_attributes!(rating_area_id: nil)}
      product
    }

    let(:valid_params) do
      {
        tenant: :dc, state: 'District of Columbia', dob: '2000-10-10', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100
      }
    end

    before :each do
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'single')
    end

    context 'with valid data' do
      context 'affordable' do
        before :each do
          @determined_result ||= subject.call(valid_params.merge!(household_amount: 1000000))
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return affordable per given data' do
            expect(@result[:hra_determination]).to eq(:affordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end

      context 'unaffordable' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        it 'should be successful' do
          expect(@determined_result.success?).to be_truthy
        end

        it 'should return a value that can be formatted to json' do
          expect{@determined_result.success.to_json}.not_to raise_error
        end

        context 'for response data' do
          before do
            @result = @determined_result.success
          end

          it 'should return a value of class Hash' do
            expect(@result.class).to eq(::Hash)
          end

          it 'should return unaffordable per given data' do
            expect(@result[:hra_determination]).to eq(:unaffordable)
          end

          it 'should not have any errors for given data' do
            expect(@result[:errors]).to be_empty
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        {state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: ''
        }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect{@determined_result.failure.to_json}.not_to raise_error
      end

      context 'for response data' do
        before do
          @result = @determined_result.failure
        end

        it 'should return a value of class Hash' do
          expect(@result.class).to eq(::Hash)
        end

        it 'should have any errors for given data' do
          expect(@result[:errors]).not_to be_empty
        end
      end
    end
  end

  after :all do
    DatabaseCleaner.clean
  end
end
