require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Operations::CreatePlan, type: :model, dbclean: :after_each do
  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'case for failure' do
    it 'should return a failure' do
      params = { plans_file: 'test.xml', year: 2020, tenant: 'tenant', import_timestamp: DateTime.now, carrier_name: 'Carrier Name'}
      expect(subject.call(params)).to eq(Dry::Monads::Result::Failure.new({errors: ['Failed to store data from file test.xml']}))
    end
  end

  context 'case for success' do
    include_context 'setup enterprise admin seed'
    let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
    let(:tenant_params) do
      { key: :dc, owner_organization_name: 'DC Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'single' }
    include_context 'setup tenant'

    before do
      @file = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/ivl_gold_pb_bcbs.xml')).first
    end

    it 'should return a success' do
      params = { plans_file: @file, year: 2020, tenant: tenant, import_timestamp: DateTime.now, carrier_name: 'Carrier Name'}
      expect(subject.call(params)).to eq(Dry::Monads::Result::Success.new('Created Plan for given data'))
    end
  end
end
