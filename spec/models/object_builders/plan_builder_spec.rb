# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib', 'tasks', 'parsers', 'plan_benefit_template_parser')
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ObjectBuilders::PlanBuilder, type: :model, dbclean: :after_each do
  before(:each) do
    DatabaseCleaner.clean
  end

  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }

  describe 'tenant with age_rated and zipcode as geographic rating area model', dbclean: :after_each do
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end

    let(:value_for_age_rated) { 'age_rated' }

    let(:value_for_geo_rating_area) { 'zipcode' }

    include_context 'setup tenant'

    let!(:service_area) { FactoryBot.create(:locations_service_area, issuer_hios_id: '42690', active_year: 2020)}
    let(:import_timestamp) { DateTime.now }

    context 'product loading non-silver plan' do
      before do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_gold_pb_bcbs.xml')).first
      end

      context 'when product loader is called with a file' do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          plan_builder = ObjectBuilders::PlanBuilder.new({ tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'MA Carrier Name' })
          plan_builder.add(product_parser.to_hash)
          plan_builder.run
        end

        it 'should not load gold product from file' do
          expect(::Products::Product.all.count).to eq 0
        end
      end
    end

    context 'product loading with invalid xml' do
      before do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_invalid.xml')).first
      end

      context "when product loader is called with a file" do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          plan_builder = ObjectBuilders::PlanBuilder.new({tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'MA Carrier Name'})
          plan_builder.add(product_parser.to_hash)
          plan_builder.run
        end

        it "should not load product from file as file is invalid" do
          expect(::Products::Product.all.count).to eq 0
        end
      end
    end

    context 'product loading silver plan' do
      before :all do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_silver_pb_bcbs.xml')).first
      end

      context "when product loader is called with a file" do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          @plan_builder = ObjectBuilders::PlanBuilder.new({tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'MA Carrier Name'})
          @plan_builder.add(product_parser.to_hash)
          @plan_builder.run
        end


        it "should load ivl products from file for MA tenant" do
          expect(tenant.products.count).to eq 2
        end

        it 'should set instance variable service_area_enabled' do
          expect(@plan_builder.instance_variable_get(:@service_area_enabled)).to be_truthy
        end

        it 'should set instance variable tenant' do
          expect(@plan_builder.instance_variable_get(:@tenant)).to eq(tenant)
        end

        it 'should set instance variable service_area_map' do
          expect(@plan_builder.instance_variable_get(:@service_area_map)).to eq({["42690", "MAS001", 2020] => service_area.id})
        end

        it 'should set carrier_name' do
          expect(tenant.products.pluck(:carrier_name).uniq).to eq(['MA Carrier Name'])
        end

        it 'should set a particular timestamp to created_at' do
          expect(tenant.products.pluck(:created_at).uniq).to eq([import_timestamp])
        end

        it 'should set service_area_map' do
          service_area_map = @plan_builder.instance_variable_get(:@service_area_map)
          expect(service_area_map.length).to eq 1
          expect(service_area_map.keys.first).to eq(["42690", "MAS001", 2020])
          expect(service_area_map.values.first).to eq(service_area.id)
        end
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

    let!(:service_area) { FactoryBot.create(:locations_service_area, issuer_hios_id: '42690', active_year: 2020, issuer_provided_code: 'MAS001', covered_states: ['NY'])}

    let!(:countyzip) { FactoryBot.create(:locations_county_zip, state: 'NY', county_name: 'New York', zip: nil) }

    let!(:rating_area) { FactoryBot.create(:locations_rating_area, active_year: 2020, county_zip_ids: [countyzip.id]) }

    let(:import_timestamp) { DateTime.now }

    context 'product loading non-silver plan' do
      before do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_gold_pb_bcbs.xml')).first
      end

      context 'when product loader is called with a file' do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          plan_builder = ObjectBuilders::PlanBuilder.new({ tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'NY Carrier Name' })
          plan_builder.add(product_parser.to_hash)
          plan_builder.run
        end

        it 'should not load gold product from file' do
          expect(::Products::Product.all.count).to eq 0
        end
      end
    end

    context 'product loading with invalid xml' do
      before do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_invalid.xml')).first
      end

      context "when product loader is called with a file" do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          plan_builder = ObjectBuilders::PlanBuilder.new({tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'NY Carrier Name'})
          plan_builder.add(product_parser.to_hash)
          plan_builder.run
        end

        it "should not load ivl product from file" do
          expect(::Products::Product.all.count).to eq 0
        end
      end
    end

    context 'product loading silver plan' do
      before :all do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_silver_pb_bcbs.xml')).first
      end

      context "when product loader is called with a file" do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          @plan_builder = ObjectBuilders::PlanBuilder.new({tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'NY Carrier Name'})
          @plan_builder.add(product_parser.to_hash)
          @plan_builder.run
        end

        it "should load ivl products from file for NY tenant" do
          expect(tenant.products.count).to eq 2
        end

        it 'should set instance variable service_area_enabled' do
          expect(@plan_builder.instance_variable_get(:@service_area_enabled)).to be_truthy
        end

        it 'should set instance variable tenant' do
          expect(@plan_builder.instance_variable_get(:@tenant)).to eq(tenant)
        end

        it 'should set instance variable service_area_map' do
          expect(@plan_builder.instance_variable_get(:@service_area_map)).to eq({["42690", "MAS001", 2020] => service_area.id})
        end

        it 'should set carrier_name' do
          expect(tenant.products.pluck(:carrier_name).uniq).to eq(['NY Carrier Name'])
        end

        it 'should set a particular timestamp to created_at' do
          expect(tenant.products.pluck(:created_at).uniq).to eq([import_timestamp])
        end

        it 'should set service_area_map' do
          service_area_map = @plan_builder.instance_variable_get(:@service_area_map)
          expect(service_area_map.length).to eq 1
          expect(service_area_map.keys.first).to eq(["42690", "MAS001", 2020])
          expect(service_area_map.values.first).to eq(service_area.id)
        end
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

    let(:import_timestamp) { DateTime.now }

    context 'product loading non-silver plan' do
      before do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_gold_pb_bcbs.xml')).first
      end

      context 'when product loader is called with a file' do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          plan_builder = ObjectBuilders::PlanBuilder.new({ tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'DC Carrier Name' })
          plan_builder.add(product_parser.to_hash)
          plan_builder.run
        end

        it 'should not load gold product from file' do
          expect(::Products::Product.all.count).to eq 0
        end
      end
    end

    context 'product loading with invalid xml' do
      before do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_invalid.xml')).first
      end

      context "when product loader is called with a file" do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          plan_builder = ObjectBuilders::PlanBuilder.new({tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'DC Carrier Name'})
          plan_builder.add(product_parser.to_hash)
          plan_builder.run
        end

        it "should not load ivl product from file" do
          expect(::Products::Product.all.count).to eq 0
        end
      end
    end

    context 'product loading silver plan' do
      before :all do
        @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_silver_pb_bcbs.xml')).first
      end

      context "when product loader is called with a file" do
        before do
          xml = Nokogiri::XML(File.open(@file))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          @plan_builder = ObjectBuilders::PlanBuilder.new({tenant: tenant, import_timestamp: import_timestamp, carrier_name: 'DC Carrier Name'})
          @plan_builder.add(product_parser.to_hash)
          @plan_builder.run
        end

        it "should load ivl products from file for DC tenant" do
          expect(tenant.products.count).to eq 2
        end

        it 'should set instance variable service_area_enabled' do
          expect(@plan_builder.instance_variable_get(:@service_area_enabled)).to be_falsy
        end

        it 'should set instance variable tenant' do
          expect(@plan_builder.instance_variable_get(:@tenant)).to eq(tenant)
        end

        it 'should set instance variable service_area_map as empty hash' do
          expect(@plan_builder.instance_variable_get(:@service_area_map)).to eq({})
        end

        it 'should set carrier_name' do
          expect(tenant.products.pluck(:carrier_name).uniq).to eq(['DC Carrier Name'])
        end

        it 'should set a particular timestamp to created_at' do
          expect(tenant.products.pluck(:created_at).uniq).to eq([import_timestamp])
        end

        it 'should not set service_area_map' do
          service_area_map = @plan_builder.instance_variable_get(:@service_area_map)
          expect(service_area_map.length).to eq 0
        end
      end
    end
  end
end
