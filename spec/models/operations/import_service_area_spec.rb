# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Operations::ImportServiceArea, type: :model, dbclean: :after_each do
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
    let(:year) { 2020 }

    context 'for success case' do
      let(:file) { 'spec/test_data/service_areas/ma_service_areas_test.xlsx' }
      let(:params) do
        { sa_file: file, year: year, tenant: tenant }
      end

      context 'without any existing ServiceArea objects' do
        before do
          ::Locations::ServiceArea.all.destroy_all
          FactoryBot.create(:locations_county_zip, county_name: 'Worcester')
          FactoryBot.create(:locations_county_zip, county_name: 'Hampshire', zip: '01082')
          FactoryBot.create(:locations_county_zip, county_name: 'Franklin', zip: '01366')
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created Service Areas for the given data'))
        end

        it 'should create ServiceArea objects' do
          expect(::Locations::ServiceArea.all.count).to eq(2)
        end
      end

      context 'with some existing ServiceArea objects' do
        let(:file) { 'spec/test_data/service_areas/ma_service_areas_test.xlsx' }
        let(:params) do
          { sa_file: file, year: year, tenant: tenant }
        end

        before do
          ::Locations::ServiceArea.all.destroy_all
          FactoryBot.create(:locations_county_zip, county_name: 'Worcester')
          FactoryBot.create(:locations_county_zip, county_name: 'Hampshire', zip: '01082')
          FactoryBot.create(:locations_county_zip, county_name: 'Franklin', zip: '01366')
          FactoryBot.create(:locations_service_area, issuer_provided_code: 'MAS002', issuer_hios_id: '12234', active_year: year, issuer_provided_title: 'Select Care ')
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created Service Areas for the given data'))
        end

        it 'should create ServiceArea objects' do
          expect(::Locations::ServiceArea.all.count).to eq(2)
        end
      end
    end

    context 'for failure case' do
      let(:params) do
        { sa_file: 'bad_file.xlsx', year: year, tenant: tenant }
      end

      before do
        ::Locations::ServiceArea.all.destroy_all
        @result ||= subject.call(params)
      end

      it 'should return failure' do
        expect(@result).to eq(Dry::Monads::Result::Failure.new({errors: ['Unable to process file: bad_file.xlsx']}))
      end

      it 'should not create ServiceArea objects' do
        expect(::Locations::ServiceArea.all.count).to be_zero
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
    let(:year) { 2020 }

    context 'for success case' do
      let(:file) { 'spec/test_data/service_areas/ny_service_areas_test.xlsx' }
      let(:params) do
        { sa_file: file, year: year, tenant: tenant }
      end

      context 'without any existing ServiceArea objects' do
        before do
          ::Locations::ServiceArea.all.destroy_all
          FactoryBot.create(:locations_county_zip, county_name: 'Bronx', state: 'NY')
          FactoryBot.create(:locations_county_zip, county_name: 'New York', state: 'NY')
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created Service Areas for the given data'))
        end

        it 'should create ServiceArea objects' do
          expect(::Locations::ServiceArea.all.count).to eq(2)
        end
      end

      context 'with some existing ServiceArea objects' do
        let(:file) { 'spec/test_data/service_areas/ny_service_areas_test.xlsx' }
        let(:params) do
          { sa_file: file, year: year, tenant: tenant }
        end

        before do
          ::Locations::ServiceArea.all.destroy_all
          FactoryBot.create(:locations_county_zip, county_name: 'Bronx', state: 'NY')
          FactoryBot.create(:locations_county_zip, county_name: 'New York', state: 'NY')
          FactoryBot.create(:locations_service_area,
                            active_year: year,
                            issuer_provided_code: 'NYS001',
                            covered_states: ['NY'],
                            issuer_provided_title: 'Healthfirst')
          @result ||= subject.call(params)
        end

        it 'should return success' do
          expect(@result).to eq(Dry::Monads::Result::Success.new('Created Service Areas for the given data'))
        end

        it 'should create ServiceArea objects' do
          expect(::Locations::ServiceArea.all.count).to eq(2)
        end
      end
    end

    context 'for failure case' do
      let(:params) do
        { sa_file: 'bad_file.xlsx', year: year, tenant: tenant }
      end

      before do
        ::Locations::ServiceArea.all.destroy_all
        @result ||= subject.call(params)
      end

      it 'should return failure' do
        expect(@result).to eq(Dry::Monads::Result::Failure.new({errors: ['Unable to process file: bad_file.xlsx']}))
      end

      it 'should not create ServiceArea objects' do
        expect(::Locations::ServiceArea.all.count).to be_zero
      end
    end
  end

end
