require 'rails_helper'
require Rails.root.join('lib', 'tasks', 'parsers', 'plan_rate_group_list_parser')
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')
require File.join(Rails.root, 'spec/shared_contexts/rates_builder_db_set_up')

describe ObjectBuilders::RateBuilder, type: :model, dbclean: :after_each do

  before(:each) do
    DatabaseCleaner.clean
  end

  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let(:year) { 2020 }

  describe 'tenant with age_rated and zipcode as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'zipcode' }
    include_context 'setup tenant'
    include_context 'setup rating areas and products for ma'

    context 'with an existing product' do
      before :each do
        tenant.products.by_application_period(application_period).each do |new_product|
          new_product.premium_tables = []
          new_product.save!
        end

        rates_runner({ rates_file: 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml', tenant: tenant, year: 2020 })
        tenant.products.each { |plan| plan.reload}
      end

      it 'should not load rates for 2019 products' do
        tenant.products.by_application_period(previous_application_period).each do |old_product|
          expect(old_product.premium_tables.count).to eq(1)
        end
      end

      it 'should load rates for 2020 products' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.count).not_to be_zero
        end
      end

      it 'should create multiple premium_tables as per rating areas' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.count).to eq(7)
        end
      end

      it 'should set rating area ids for all premium_tables' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.map(&:rating_area_id)).not_to include(nil)
        end
      end

      it 'should set instance variable rating_area_id_required' do
        expect(@rate_builder.instance_variable_get(:@rating_area_id_required)).to be_truthy
      end

      it 'should set instance variable rating_area_id_cache' do
        expect(@rate_builder.instance_variable_get(:@rating_area_id_cache).length).to eq(8)
      end
    end

    context 'with a non-existing product' do
      before :each do
        tenant.products.by_application_period(application_period).destroy_all
      end

      it 'should not raise any error is there are no matching products' do
        expect { rates_runner({ rates_file: 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml', tenant: tenant, year: 2020 }) }.not_to raise_error
      end
    end

    context 'without rating areas' do
      before :each do
        ::Locations::RatingArea.all.destroy_all
      end

      it 'should raise run time error' do
        params = { rates_file: 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml', tenant: tenant, year: 2020 }
        expect { rates_runner(params) }.to raise_error(RuntimeError, /Failed to create premium table for hios_id/)
      end
    end
  end

  describe 'tenant with non_age_rated and county as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :ny, owner_organization_name: 'NY Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'non_age_rated' }
    let(:value_for_geo_rating_area) { 'county' }
    include_context 'setup tenant'
    include_context 'setup rating areas and products for ny'

    context 'with an existing product' do
      before :each do
        tenant.products.by_application_period(application_period).each do |new_product|
          new_product.premium_tables = []
          new_product.save!
        end

        rates_runner({ rates_file: 'spec/test_data/plan_data/rates/ivl_silver_non_age_rated.xml', tenant: tenant, year: 2020 })
        tenant.products.each { |plan| plan.reload}
      end

      it 'should not load rates for 2019 products' do
        tenant.products.by_application_period(previous_application_period).each do |old_product|
          expect(old_product.premium_tables.count).to eq(1)
        end
      end

      it 'should load rates for 2020 products' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.count).not_to be_zero
        end
      end

      it 'should set rating area ids for all premium_tables' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.map(&:rating_area_id)).not_to include(nil)
        end
      end

      it 'should set instance variable rating_area_id_required' do
        expect(@rate_builder.instance_variable_get(:@rating_area_id_required)).to be_truthy
      end

      it 'should set instance variable rating_area_id_cache' do
        expect(@rate_builder.instance_variable_get(:@rating_area_id_cache).length).not_to be_zero
      end
    end

    context 'with a non-existing product' do
      before :each do
        tenant.products.by_application_period(application_period).destroy_all
      end

      it 'should not raise any error is there are no matching products' do
        expect { rates_runner({ rates_file: 'spec/test_data/plan_data/rates/ivl_silver_non_age_rated.xml', tenant: tenant, year: 2020 }) }.not_to raise_error
      end
    end

    context 'without rating areas' do
      before :each do
        ::Locations::RatingArea.all.destroy_all
      end

      it 'should raise run time error' do
        params = { rates_file: 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml', tenant: tenant, year: 2020 }
        expect { rates_runner(params) }.to raise_error(RuntimeError, /Failed to create premium table for hios_id/)
      end
    end
  end

  describe 'tenant with age_rated and single as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :dc, owner_organization_name: 'DC Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'single' }
    include_context 'setup tenant'
    include_context 'setup products for dc'

    context 'with an existing product' do
      before do
        ::Locations::ServiceArea.all.destroy_all
        ::Locations::RatingArea.all.destroy_all
        ::Locations::CountyZip.all.destroy_all
      end

      before :each do
        tenant.products.by_application_period(application_period).each do |new_product|
          new_product.premium_tables = []
          new_product.save!
        end

        rates_runner({ rates_file: 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml', tenant: tenant, year: 2020 })
        tenant.products.each { |plan| plan.reload}
      end

      it 'should not load rates for 2019 products' do
        tenant.products.by_application_period(previous_application_period).each do |old_product|
          expect(old_product.premium_tables.count).to eq(1)
        end
      end

      it 'should load rates for 2020 products' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.count).to eq(1)
        end
      end

      it 'should not set rating area ids for all premium_tables' do
        tenant.products.by_application_period(application_period).each do |new_product|
          expect(new_product.premium_tables.pluck(:rating_area_id).uniq.first).to be_nil
        end
      end

      it 'should set instance variable rating_area_id_required' do
        expect(@rate_builder.instance_variable_get(:@rating_area_id_required)).to be_falsy
      end

      it 'should set instance variable rating_area_id_cache' do
        expect(@rate_builder.instance_variable_get(:@rating_area_id_cache).length).to be_zero
      end
    end

    context 'with a non-existing product' do
      before :each do
        tenant.products.by_application_period(application_period).destroy_all
      end

      it 'should not raise any error is there are no matching products' do
        expect { rates_runner({ rates_file: 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml', tenant: tenant, year: 2020 }) }.not_to raise_error
      end
    end
  end
end

def rates_runner(rates_params)
  files = [rates_params[:rates_file]]
  year = rates_params[:year].to_i
  tenant = rates_params[:tenant]
  @rate_builder = ::ObjectBuilders::RateBuilder.new({tenant: tenant})
  rate_import_hash = files.inject(@rate_builder) do |rate_hash, file|
    xml = Nokogiri::XML(File.open(file))
    rates = Parser::PlanRateGroupListParser.parse(xml.root.canonicalize, :single => true)
    rate_hash.add(rates.to_hash, "new", year)
    rate_hash
  end
  rate_import_hash.run
end
