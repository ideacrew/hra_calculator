require 'rails_helper'

RSpec.describe Enterprises::EnterprisePolicy, dbclean: :around_each do

  let!(:enterprise) { FactoryBot.create(:enterprise) }
  let!(:enterprise_owner) { FactoryBot.create(:account, enterprise: enterprise) }
  let!(:other_account) { FactoryBot.create(:account) }

  subject { described_class }

  permissions :can_modify? do

    it 'grants access if acocunt belongs to enterprise owner' do
      expect(subject).to permit(enterprise_owner, enterprise)
    end

    it 'denies access if account belongs to a non owner' do
      expect(subject).not_to permit(other_account, enterprise)
    end
  end
end
