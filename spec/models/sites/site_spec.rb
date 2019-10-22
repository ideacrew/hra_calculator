require 'rails_helper'

RSpec.describe Sites::Site, type: :model do

  before do
    DatabaseCleaner.clean
    @tenant = FactoryBot.create(:tenant, enterprise: FactoryBot.create(:enterprise))
    @site = FactoryBot.create(:site, tenant: @tenant)
  end

  it "returns its tenant" do
    expect(@site.tenant).to eq(@tenant)
  end

  it "accepts many features" do
    feature_1 = FactoryBot.create(:feature, site: @site)
    feature_2 = FactoryBot.create(:feature, site: @site)

    expect(@site.features.count).to eq(2)
  end

  it "accepts many options" do
    @site.options << FactoryBot.create(:option)
    @site.options << FactoryBot.create(:option)

    expect(@site.options.count).to eq(2)
  end

  xit "accepts multiple environments" do
  end

  xit "returns its environments" do
  end

  xit "returns itself as a hash" do
  end
end
