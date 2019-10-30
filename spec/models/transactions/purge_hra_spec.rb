require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Transactions::PurgeHra, dbclean: :after_each do
  include_context 'setup enterprise admin seed'

  context 'for success case' do
    let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
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

    before do
      @result = subject.call
    end

    it 'should return Success' do
      expect(@result).to eq(Dry::Monads::Result::Success.new('Process done'))
    end

    it 'should delete collections' do
      expect(::Products::Product.all.count).to be_zero
      expect(::Locations::ServiceArea.all.count).to be_zero
      expect(::Locations::RatingArea.all.count).to be_zero
      expect(::Locations::CountyZip.all.count).to be_zero
      expect(::Account.where(email: 'admin@market_place.org').all.count).to be_zero
      expect(::Tenants::Tenant.all.count).to be_zero
      expect(::HraDetermination.all.count).to be_zero
    end
  end

  context 'for failure case' do
    it 'should return Failure with some errors' do
      expect(subject.call).to eq(Dry::Monads::Result::Failure.new({errors: ['There are no tenants.']}))
    end
  end
end
