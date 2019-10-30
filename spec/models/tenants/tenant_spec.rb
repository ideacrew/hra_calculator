require 'rails_helper'

RSpec.describe Tenants::Tenant, type: :model do

  before do
    DatabaseCleaner.clean

    @account    = FactoryBot.create(:account)
    @enterprise = FactoryBot.create(:enterprise, owner_account: @account)
    @tenant     = FactoryBot.create(:tenant, enterprise: @enterprise)

  end

  it "returns its enterprise" do
    expect(@tenant.enterprise).to eq(@enterprise)
  end

  it "accepts many owner accounts" do
    account_1 = FactoryBot.create(:account, tenant: @tenant)
    account_2 = FactoryBot.create(:account, tenant: @tenant)

    expect(@tenant.owner_accounts.count).to eq(2)
  end

  it "accepts many products" do
    product_1 = FactoryBot.create(:products_health_product, tenant: @tenant)
    product_2 = FactoryBot.create(:products_health_product, tenant: @tenant)

    expect(@tenant.products.count).to eq(2)
  end

  it "accepts many sites" do
    site_1 = FactoryBot.create(:site, tenant: @tenant)
    site_2 = FactoryBot.create(:site, tenant: @tenant)

    expect(@tenant.sites.count).to eq(2)
  end

  it "accepts many options" do
    @tenant.options << FactoryBot.create(:option)
    @tenant.options << FactoryBot.create(:option)

    expect(@tenant.options.count).to eq(2)
  end

  it "returns tenant features" do
    site_1 = FactoryBot.create(:site, tenant: @tenant)
    feature_1 = FactoryBot.create(:feature, site: site_1)
    option_1 = FactoryBot.create(:option, key: :rating_area_model, value: "Single Rating Area", default: "nil", namespace: false)
    option_2 = FactoryBot.create(:option, key: :use_age_ratings, value: "Age Ratings", default: "nil", namespace: false )
    feature_1.options << option_1
    feature_1.options << option_2

    expect(@tenant.features).to eq({:rating_area_model=>"Single Rating Area", :use_age_ratings=>"Age Ratings"})
    expect(@tenant.geographic_rating_area_model).to eq("Single Rating Area")
    expect(@tenant.use_age_ratings).to eq("Age Ratings")
  end

  xit "can update multiple sites" do
  end

  xit "can find tenant by key" do 
  end
end
