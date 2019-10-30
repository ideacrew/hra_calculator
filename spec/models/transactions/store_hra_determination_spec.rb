# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Transactions::StoreHraDetermination, dbclean: :after_each do
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
                                            start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly',
                                            hra_amount: 1000, member_premium: 315.23, age: 12, hra: 0.73, hra_determination: :affordable,
                                            rating_area_id: 'asjh73572vjadhh', service_area_ids: ['sdjhg23765'], errors: [],
                                            hios_id: 'hgsvd763-00', plan_name: 'Plan Name', carrier_name: 'Carrier Name'}
      )
    end

    context 'for storing HraDetermination' do
      before do
        @result = subject.call({hra_object: hra_object, expected_contribution: benefit_year.expected_contribution}).success
        @hra_determination_object = ::HraDetermination.all.first
      end

      it 'should create HraDetermination object' do
        expect(::HraDetermination.all.count).to eq(1)
      end

      it 'should create HraDetermination object with values for all fields' do
        expect(@hra_determination_object.attributes.values).not_to include(nil)
      end

      it 'should create HraDetermination object with expected values for fields' do
        expect(@hra_determination_object.zipcode).to eq(hra_object.zipcode)
        expect(@hra_determination_object.county).to eq(hra_object.county)
      end
    end
  end

  describe 'tenant with non_age_rated and county' do
    before do
      tenant.update_attributes!(key: :ny, owner_organization_name: 'NY Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'non_age_rated')
      options.second.update_attributes!(value: 'county')
      countyzip.update_attributes!(zip: nil, county_name: 'Albany', state: 'NY' )
    end

    let(:hra_object) do
      ::HraAffordabilityDetermination.new({ tenant: :ny, state: 'New York', zipcode: nil, county: 'Albany',
                                            dob: nil, household_frequency: 'monthly', household_amount: 1000, hra_type: 'ichra',
                                            start_month: Date.new(2020), end_month: Date.new(2020, 12, 31), hra_frequency: 'monthly',
                                            hra_amount: 1000, member_premium: 315.23, age: nil, hra: 0.73, hra_determination: :affordable,
                                            rating_area_id: 'asjh73572vjadhh', service_area_ids: ['sdjhg23765'], errors: [],
                                            hios_id: 'hgsvd763-00', plan_name: 'Plan Name', carrier_name: 'Carrier Name'}
      )
    end

    context 'for storing HraDetermination' do
      before do
        @result = subject.call({hra_object: hra_object, expected_contribution: benefit_year.expected_contribution}).success
        @hra_determination_object = ::HraDetermination.all.first
      end

      it 'should create HraDetermination object' do
        expect(::HraDetermination.all.count).to eq(1)
      end

      it 'should create HraDetermination object with values for all fields except zipcode, dob and age' do
        expect(@hra_determination_object.attributes.except('zipcode', 'dob', 'age').values).not_to include(nil)
      end

      it 'should create HraDetermination object with expected values for fields' do
        expect(@hra_determination_object.zipcode).to eq(hra_object.zipcode)
        expect(@hra_determination_object.county).to eq(hra_object.county)
      end
    end
  end

  describe 'tenant with age_rated and single' do
    before do
      tenant.update_attributes!(key: :dc, owner_organization_name: 'DC Marketplace')
      options = tenant.sites.first.features.first.options.first.options
      options.first.update_attributes!(value: 'age_rated')
      options.second.update_attributes!(value: 'single')
    end

    let(:hra_object) do
      ::HraAffordabilityDetermination.new({ tenant: :dc, state: 'District of Columbia', zipcode: nil, county: nil,
                                            dob: Date.new(2000), household_frequency: 'monthly', household_amount: 1000,
                                            hra_type: 'ichra', start_month: Date.new(2020), end_month: Date.new(2020, 12, 31),
                                            hra_frequency: 'monthly', hra_amount: 1000, member_premium: 315.23, age: 19,
                                            hra: 0.73, hra_determination: :affordable, rating_area_id: nil,
                                            service_area_ids: [], errors: [], hios_id: 'hgsvd763-00',
                                            plan_name: 'Plan Name', carrier_name: 'Carrier Name'}
      )
    end

    context 'for storing HraDetermination' do
      before do
        @result = subject.call({hra_object: hra_object, expected_contribution: benefit_year.expected_contribution}).success
        @hra_determination_object = ::HraDetermination.all.first
      end

      it 'should create HraDetermination object' do
        expect(::HraDetermination.all.count).to eq(1)
      end

      it 'should create HraDetermination object with values for all fields except for some' do
        attr_hash = @hra_determination_object.attributes.except('zipcode', 'county', 'rating_area_id', 'service_area_ids')
        expect(attr_hash.values).not_to include(nil)
      end

      it 'should create HraDetermination object with expected values for fields' do
        expect(@hra_determination_object.zipcode).to eq(hra_object.zipcode)
        expect(@hra_determination_object.county).to eq(hra_object.county)
      end
    end
  end
end
