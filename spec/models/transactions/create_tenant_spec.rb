require "rails_helper"

RSpec.describe Transactions::CreateTenant, dbclean: :after_each do

  let!(:enterprise)    { FactoryBot.create(:enterprise) }
  let!(:account_email) { 'admin@healthconnector.com' }
  let(:params)         { { key: :ma, owner_organization_name: 'MA Health Connector', account_email: account_email} }
  subject              { described_class.new(params) }

  context "with valid params" do
    let!(:account)       { FactoryBot.create(:account, email: account_email) }

    it 'should create a tenant' do
      result = subject.with_step_args(fetch: [enterprise: enterprise]).call(params)

      expect(result.success?).to be_truthy
      result_obj = result.value!
      expect(result_obj).to be_an_instance_of(Tenants::Tenant)
      expect(result_obj.key).to eq params[:key]
      expect(result_obj.owner_accounts).to include(account) 
    end
  end

  context "when existing tenant key is passed" do
    let!(:ma_tenant)       { FactoryBot.create(:tenant, enterprise: enterprise, key: :ma) }
    let!(:account)         { FactoryBot.create(:account, email: account_email) }

    it 'should fail with error message' do
      result = subject.with_step_args(fetch: [enterprise: enterprise]).call(params)

      expect(result.failure?).to be_truthy
      messages = result.failure
      expect(messages[:errors]).to be_present
      expect(messages[:errors][:marketplace]).to eq 'already exists for the selected state.'
    end
  end

  context "when account already associated with another marketplace" do

    let!(:ca_tenant)       { FactoryBot.create(:tenant, enterprise: enterprise, key: :ca) }
    let!(:ca_tenant_owner) { FactoryBot.create(:account, tenant: ca_tenant, email: account_email) }

    it 'should fail with error message' do
      result = subject.with_step_args(fetch: [enterprise: enterprise]).call(params)

      expect(result.failure?).to be_truthy
      messages = result.failure
      expect(messages[:errors]).to be_present
      expect(messages[:errors][:account_email]).to eq "(#{account_email}) is owner for another marketplace. Please choose different account."
    end
  end
end