require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')
require File.join(Rails.root, 'spec/shared_contexts/rates_builder_db_set_up')

RSpec.describe Operations::CreateRates, type: :model, dbclean: :after_each do
  let(:year) { 2020 }

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'case for failure' do
    it 'should return a failure' do
      params = { rates_file: 'test.xml', year: year, tenant: 'tenant'}
      expect(subject.call(params)).to eq(Dry::Monads::Result::Failure.new({errors: ['Failed to store data from file test.xml']}))
    end
  end

  context 'case for success' do
    include_context 'setup enterprise admin seed'
    let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'zipcode' }
    include_context 'setup tenant'
    include_context 'setup rating areas and products for ma'

    before do
      @file = 'spec/test_data/plan_data/rates/ivl_silver_age_rated.xml'
    end

    it 'should return a success' do
      expect(subject.call({ rates_file: @file, tenant: tenant, year: year })).to eq(Dry::Monads::Result::Success.new('Created Rates for given data'))
    end
  end
end
