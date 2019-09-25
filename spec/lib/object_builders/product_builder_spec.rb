# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib', 'object_builders', 'product_builder')
require Rails.root.join('lib', 'tasks', 'parsers', 'plan_benefit_template_parser')

describe "qhp builder", dbclean: :after_each do
  before :all do
    FactoryBot.create(:locations_service_area, issuer_provided_code: "MAS001", active_year: 2019, issuer_hios_id: "42690")
    FactoryBot.create(:locations_service_area, issuer_provided_code: "MAS002", active_year: 2019, issuer_hios_id: "42690")
  end

  context 'product loading non-silver plan' do
    before :all do
      @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_gold_pb_bcbs.xml')).first
      @product = FactoryBot.create(:products_health_product, hios_id: "42690MA1234502-01", hios_base_id: "42690MA1234502", csr_variant_id: "01", application_period: Date.new(2019, 1, 1)..Date.new(2019, 12, 31))
    end

    it "should have 1 existing product" do
      expect(::Products::Product.all.count).to eq 1
    end

    context "when product loader is called with a file" do
      before(:all) do
        xml = Nokogiri::XML(File.open(@file))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      it "should not load ivl product from file" do
        expect(::Products::Product.all.count).to eq 1
      end
    end
  end


  context 'product loading with invalid xml' do
    before :all do
      @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_invalid.xml')).first
      @product = FactoryBot.create(:products_health_product, hios_id: "42690MA1234502-01", hios_base_id: "42690MA1234502", csr_variant_id: "01", application_period: Date.new(2019, 1, 1)..Date.new(2019, 12, 31))
    end

    it "should have 2 existing products" do
      expect(::Products::Product.all.count).to eq 2
    end

    context "when product loader is called with a file" do
      before(:all) do
        xml = Nokogiri::XML(File.open(@file))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      it "should load ivl product from file" do
        expect(::Products::Product.all.count).to eq 2
      end
    end
  end

  context 'product loading silver plan' do
    before :all do
      @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_silver_pb_bcbs.xml')).first
      @product = FactoryBot.create(:products_health_product, hios_id: "42690MA1234502-01", hios_base_id: "42690MA1234502", csr_variant_id: "01", application_period: Date.new(2019, 1, 1)..Date.new(2019, 12, 31))
    end

    it "should have 2 existing products" do
      expect(::Products::Product.all.count).to eq 3
    end

    context "when product loader is called with a file" do
      before(:all) do
        xml = Nokogiri::XML(File.open(@file))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      it "should load ivl product from file" do
        expect(::Products::Product.all.count).to eq 4
      end
    end
  end

  after :all do
    DatabaseCleaner.clean
  end
end
