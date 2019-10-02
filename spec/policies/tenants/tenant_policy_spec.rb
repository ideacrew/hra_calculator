require 'rails_helper'

RSpec.describe Tenants::TenantPolicy, dbclean: :around_each do

  let!(:enterprise)       { FactoryBot.create(:enterprise) }
  let!(:enterprise_owner) { FactoryBot.create(:account, enterprise: enterprise) }

  let!(:tenant_one)       { FactoryBot.create(:tenant, enterprise: enterprise) }
  let!(:tenant_one_owner) { FactoryBot.create(:account, tenant: tenant_one) }
  
  let!(:tenant_two)       { FactoryBot.create(:tenant, enterprise: enterprise) }
  let!(:tenant_two_owner) { FactoryBot.create(:account, tenant: tenant_two) }

  subject { described_class }

  permissions :can_modify? do
    
    it 'grants access if acocunt belongs to enterprise owner' do
      expect(subject).to permit(enterprise_owner, tenant_one)
      expect(subject).to permit(enterprise_owner, tenant_two)
    end

    it 'grant access if account belongs to tenant owner' do
      expect(subject).to permit(tenant_one_owner, tenant_one)
      expect(subject).to permit(tenant_two_owner, tenant_two)
    end

    it 'denies access if account not belongs to tenant owner' do
      expect(subject).not_to permit(tenant_one_owner, tenant_two)
      expect(subject).not_to permit(tenant_two_owner, tenant_one)
    end
  end
end