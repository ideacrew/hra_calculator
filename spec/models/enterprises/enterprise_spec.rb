require 'rails_helper'

RSpec.describe Enterprises::Enterprise, type: :model do

  before do
    DatabaseCleaner.clean

    @account    = FactoryBot.create(:account)
    @enterprise = FactoryBot.create(:enterprise, owner_account: @account)
  end

  it "returns an owner account name" do
    expect(@account.email).to eq(@enterprise.owner_account_name)
  end

  it "accepts many benefit years" do
    benefit_year_1 = FactoryBot.create(:benefit_year, enterprise: @enterprise)
    benefit_year_2 = FactoryBot.create(:benefit_year, enterprise: @enterprise)

    expect(@enterprise.benefit_years.count).to eq(2)
  end

  it "accepts many tenants" do
    tenant_1 = FactoryBot.create(:tenant, enterprise: @enterprise)
    tenant_2 = FactoryBot.create(:tenant, enterprise: @enterprise)

    expect(@enterprise.tenants.count).to eq(2)
  end

  it "accepts many options" do
    @enterprise.options << FactoryBot.create(:option)
    @enterprise.options << FactoryBot.create(:option)

    expect(@enterprise.options.count).to eq(2)
  end
end
