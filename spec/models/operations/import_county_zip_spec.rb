# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Operations::ImportCountyZip, type: :model, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  describe 'tenant with age_rated and zipcode as geographic rating area model' do
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'zipcode' }
    include_context 'setup tenant'
    let!(:service_area) { FactoryBot.create(:locations_service_area, issuer_hios_id: '42690', active_year: 2020)}
    let(:import_timestamp) { DateTime.now }
    let(:year) { 2020 }

    context 'for success case' do
      context 'without any existing CountyZips' do
        let(:file) { 'spec/test_data/rating_areas/ma_county_zipcode.xlsx' }
        let(:params) do
          {file: file, year: year, tenant: tenant, import_timestamp: DateTime.now}
        end

        before :each do
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created CountyZips for given data'))
        end

        it 'should create CountyZip object' do
          expect(::Locations::CountyZip.all.count).to eq(713)
        end

        it 'should create CountyZip object for MA tenant' do
          expect(::Locations::CountyZip.all.pluck(:state).uniq).to eq(['MA'])
        end

        it 'should create CountyZip objects with zipcode' do
          expect(::Locations::CountyZip.all.pluck(:zip)).not_to include(nil)
        end
      end

      context 'with some existing CountyZips' do
        let(:file) { 'spec/test_data/rating_areas/ma_county_zipcode.xlsx' }
        let(:params) do
          {file: file, year: year, tenant: tenant, import_timestamp: DateTime.now}
        end

        before :each do
          FactoryBot.create(:locations_county_zip, zip: '01001', county_name: 'Hampden')
          FactoryBot.create(:locations_county_zip, zip: '01002', county_name: 'Franklin')
          FactoryBot.create(:locations_county_zip, zip: '01002', county_name: 'Hampshire')
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created CountyZips for given data'))
        end

        it 'should create CountyZip object' do
          expect(::Locations::CountyZip.all.count).to eq(713)
        end

        it 'should create CountyZip object for MA tenant' do
          expect(::Locations::CountyZip.all.pluck(:state).uniq).to eq(['MA'])
        end

        it 'should create CountyZip objects with zipcode' do
          expect(::Locations::CountyZip.all.pluck(:zip)).not_to include(nil)
        end
      end
    end

    context 'for failure case' do
      let(:params) do
        {file: 'bad_file.xlsx', year: year, tenant: tenant, import_timestamp: DateTime.now}
      end

      before :each do
        @result ||= subject.call(params)
      end

      it 'should return failure' do
        expect(@result).to eq(Dry::Monads::Result::Failure.new({errors: ['Unable to create data from file bad_file.xlsx']}))
      end

      it 'should not create CountyZip object' do
        expect(::Locations::CountyZip.all.count).to be_zero
      end
    end
  end

  describe 'tenant with non_age_rated and county as geographic rating area model' do
    let(:tenant_params) do
      { key: :ny, owner_organization_name: 'NY Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'non_age_rated' }
    let(:value_for_geo_rating_area) { 'county' }
    include_context 'setup tenant'
    let!(:service_area) { FactoryBot.create(:locations_service_area, issuer_hios_id: '42690', active_year: 2020)}
    let(:import_timestamp) { DateTime.now }
    let(:year) { 2020 }

    context 'for success case' do
      context 'without any existing CountyZips' do
        let(:file) { 'spec/test_data/rating_areas/ny_county_zipcode.xlsx' }
        let(:params) do
          {file: file, year: year, tenant: tenant, import_timestamp: DateTime.now}
        end

        before :each do
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created CountyZips for given data'))
        end

        it 'should create CountyZip object' do
          expect(::Locations::CountyZip.all.count).to eq(62)
        end

        it 'should create CountyZip object for NY tenant' do
          expect(::Locations::CountyZip.all.pluck(:state).uniq).to eq(['NY'])
        end

        it 'should create CountyZip objects with zipcode' do
          expect(::Locations::CountyZip.all.pluck(:zip).uniq).to eq([nil])
        end
      end

      context 'with some existing CountyZips' do
        let(:file) { 'spec/test_data/rating_areas/ny_county_zipcode.xlsx' }
        let(:params) do
          {file: file, year: year, tenant: tenant, import_timestamp: DateTime.now}
        end

        before :each do
          FactoryBot.create(:locations_county_zip, zip: nil, county_name: 'Albany', state: 'NY')
          FactoryBot.create(:locations_county_zip, zip: nil, county_name: 'Rensselaer', state: 'NY')
          FactoryBot.create(:locations_county_zip, zip: nil, county_name: 'Saratoga', state: 'NY')
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created CountyZips for given data'))
        end

        it 'should create CountyZip object' do
          expect(::Locations::CountyZip.all.count).to eq(62)
        end

        it 'should create CountyZip object for NY tenant' do
          expect(::Locations::CountyZip.all.pluck(:state).uniq).to eq(['NY'])
        end

        it 'should create CountyZip objects with zipcode' do
          expect(::Locations::CountyZip.all.pluck(:zip).uniq).to eq([nil])
        end
      end
    end

    context 'for failure case' do
      let(:params) do
        {file: 'bad_file.xlsx', year: year, tenant: tenant, import_timestamp: DateTime.now}
      end

      before :each do
        @result ||= subject.call(params)
      end

      it 'should return failure' do
        expect(@result).to eq(Dry::Monads::Result::Failure.new({errors: ['Unable to create data from file bad_file.xlsx']}))
      end

      it 'should not create CountyZip object' do
        expect(::Locations::CountyZip.all.count).to be_zero
      end
    end
  end
end
