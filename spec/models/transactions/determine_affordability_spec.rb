# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Transactions::DetermineAffordability, dbclean: :after_each do
  include_context 'setup enterprise admin seed'

  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }

  describe 'tenant with age_rated and zipcode' do
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'zipcode' }

    include_context 'setup tenant'

    let!(:product1) do
      product = FactoryBot.create(:products_health_product, tenant: tenant, application_period: Date.new(2020, 1, 1)..Date.new(2020, 12, 31))
      product&.service_area&.update_attributes!(active_year: 2020)
      product.premium_tables.each { |pt| pt&.rating_area&.update_attributes!(active_year: 2020) }
      product
    end

    let(:countyzip) { ::Locations::CountyZip.find(product1.premium_tables.first.rating_area.county_zip_ids.first.to_s) }

    let(:valid_params) do
      {
        tenant: :ma, state: 'Massachusetts', dob: '2000-10-10', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100, zipcode: countyzip.zip, county: countyzip.county_name
      }
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
          expect { @determined_result.success.to_json }.not_to raise_error
        end

        context 'for response data' do
          before do
            @result ||= @determined_result.success
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
          expect { @determined_result.success.to_json }.not_to raise_error
        end

        context 'for response data' do
          before do
            @result ||= @determined_result.success
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

      context 'for initialized dry structs' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        context 'for tenant dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@tenant)
          end

          it 'should be an object of Tenant' do
            expect(@dry_struct).to be_a ::Tenant
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for benefit_year dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@benefit_year)
          end

          it 'should be an object of benefit_year' do
            expect(@dry_struct).to be_a ::BenefitYear
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for member dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@member)
          end

          it 'should be an object of member' do
            expect(@dry_struct).to be_a ::Member
          end

          it 'should have all non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for low_cost_reference_plan dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@low_cost_reference_plan)
          end

          it 'should be an object of low_cost_reference_plan' do
            expect(@dry_struct).to be_a ::LowCostReferencePlan
          end

          it 'should have non blank values' do
            expect(@dry_struct.attributes.values.any?(&:blank?)).to be_falsy
          end
        end

        context 'for hra dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@hra)
          end

          it 'should be an object of hra' do
            expect(@dry_struct).to be_a ::Hra
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for hra_affordability dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@hra_affordability)
          end

          it 'should be an object of hra_affordability' do
            expect(@dry_struct).to be_a ::HraAffordabilityDetermination
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        { state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: '' }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect { @determined_result.failure.to_json }.not_to raise_error
      end

      context 'for response data' do
        before do
          @result ||= @determined_result.failure
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
    let(:tenant_params) do
      { key: :ny, owner_organization_name: 'NY Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'non_age_rated' }
    let(:value_for_geo_rating_area) { 'county' }

    include_context 'setup tenant'

    let!(:product1) do
      product = FactoryBot.create(:products_health_product, tenant: tenant, application_period: Date.new(2020, 1, 1)..Date.new(2020, 12, 31))
      product&.service_area&.update_attributes!(active_year: 2020, covered_states: ['NY'])
      product.premium_tables.each { |pt| pt&.rating_area&.update_attributes!(active_year: 2020) }
      product
    end

    let(:countyzip) do
      county_zip = ::Locations::CountyZip.find(product1.premium_tables.first.rating_area.county_zip_ids.first.to_s)
      county_zip.update_attributes!(state: 'NY', county_name: 'New York', zip: nil)
      county_zip
    end

    let(:valid_params) do
      {
        tenant: :ny, state: 'New York', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100, county: countyzip.county_name
      }
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
          expect { @determined_result.success.to_json }.not_to raise_error
        end

        context 'for response data' do
          before do
            @result ||= @determined_result.success
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
          expect { @determined_result.success.to_json }.not_to raise_error
        end

        context 'for response data' do
          before do
            @result ||= @determined_result.success
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

      context 'for initialized dry structs' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        context 'for tenant dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@tenant)
          end

          it 'should be an object of Tenant' do
            expect(@dry_struct).to be_a ::Tenant
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for benefit_year dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@benefit_year)
          end

          it 'should be an object of benefit_year' do
            expect(@dry_struct).to be_a ::BenefitYear
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for member dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@member)
          end

          it 'should be an object of member' do
            expect(@dry_struct).to be_a ::Member
          end

          it 'should have non nil values for some attributes' do
            expect(@dry_struct.attributes.except(:date_of_birth, :age, :zipcode, :premium_age).values).not_to include(nil)
          end

          it 'should have nil values for some attributes' do
            expect(@dry_struct.attributes.slice(:date_of_birth, :age, :zipcode, :premium_age).values.uniq).to eq([nil])
          end
        end

        context 'for low_cost_reference_plan dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@low_cost_reference_plan)
          end

          it 'should be an object of low_cost_reference_plan' do
            expect(@dry_struct).to be_a ::LowCostReferencePlan
          end

          it 'should have non blank values' do
            expect(@dry_struct.attributes.values.any?(&:blank?)).to be_falsy
          end
        end

        context 'for hra dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@hra)
          end

          it 'should be an object of hra' do
            expect(@dry_struct).to be_a ::Hra
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for hra_affordability dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@hra_affordability)
          end

          it 'should be an object of hra_affordability' do
            expect(@dry_struct).to be_a ::HraAffordabilityDetermination
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        { state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: '' }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end

      it 'should return a value that can be formatted to json' do
        expect { @determined_result.failure.to_json }.not_to raise_error
      end

      context 'for response data' do
        before do
          @result ||= @determined_result.failure
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

  describe 'tenant with age_rated and single' do
    let(:tenant_params) do
      { key: :dc, owner_organization_name: 'DC Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'single' }

    include_context 'setup tenant'

    let!(:product1) do
      product = FactoryBot.create(:products_health_product, tenant: tenant, application_period: Date.new(2020, 1, 1)..Date.new(2020, 12, 31), service_area_id: nil)
      product.premium_tables.each { |pt| pt.update_attributes!(rating_area_id: nil) }
      product
    end

    let(:valid_params) do
      {
        tenant: :dc, state: 'District of Columbia', dob: '2000-10-10', household_frequency: 'annually',
        household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
        hra_frequency: 'monthly', hra_amount: 100
      }
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
          expect { @determined_result.success.to_json }.not_to raise_error
        end

        context 'for response data' do
          before do
            @result ||= @determined_result.success
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
          expect { @determined_result.success.to_json }.not_to raise_error
        end

        context 'for response data' do
          before do
            @result ||= @determined_result.success
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

      context 'for initialized dry structs' do
        before :each do
          @determined_result ||= subject.call(valid_params)
        end

        context 'for tenant dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@tenant)
          end

          it 'should be an object of Tenant' do
            expect(@dry_struct).to be_a ::Tenant
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for benefit_year dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@benefit_year)
          end

          it 'should be an object of benefit_year' do
            expect(@dry_struct).to be_a ::BenefitYear
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for member dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@member)
          end

          it 'should be an object of member' do
            expect(@dry_struct).to be_a ::Member
          end

          it 'should have non nil values for specific keys' do
            expect(@dry_struct.attributes.except(:county, :zipcode).values).not_to include(nil)
          end

          it 'should have nil values for specific keys' do
            expect(@dry_struct.attributes.slice(:county, :zipcode).values.uniq).to eq([nil])
          end
        end

        context 'for low_cost_reference_plan dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@low_cost_reference_plan)
          end

          it 'should be an object of low_cost_reference_plan' do
            expect(@dry_struct).to be_a ::LowCostReferencePlan
          end

          it 'should have non blank values for specific attributes' do
            expect(@dry_struct.attributes.except(:service_area_ids, :rating_area_id).values.any?(&:blank?)).to be_falsy
          end

          it 'should have blank values for specific attributes' do
            expect(@dry_struct.attributes.slice(:service_area_ids, :rating_area_id).values.any?(&:blank?)).to be_truthy
          end
        end

        context 'for hra dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@hra)
          end

          it 'should be an object of hra' do
            expect(@dry_struct).to be_a ::Hra
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end

        context 'for hra_affordability dry struct' do
          before :each do
            @dry_struct = subject.instance_variable_get(:@hra_affordability)
          end

          it 'should be an object of hra_affordability' do
            expect(@dry_struct).to be_a ::HraAffordabilityDetermination
          end

          it 'should have non nil values' do
            expect(@dry_struct.attributes.values).not_to include(nil)
          end
        end
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        { state: '', dob: '2000-10-10', household_frequency: 'annually',
          household_amount: 10000, hra_type: 'ichra', start_month: '2020-1-1', end_month: '2020-12-1',
          hra_frequency: 'monthly', hra_amount: 100, zipcode: '', county: '' }
      end

      before :each do
        @determined_result ||= subject.call(invalid_params)
      end

      it 'should not be successful' do
        expect(@determined_result.success?).to be_falsey
      end
      it 'should return a value that can be formatted to json' do
        expect { @determined_result.failure.to_json }.not_to raise_error
      end

      context 'for response data' do
        before do
          @result ||= @determined_result.failure
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
end
