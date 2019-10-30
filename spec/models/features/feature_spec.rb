require 'rails_helper'

RSpec.describe Features::Feature, type: :model do

  before do
    DatabaseCleaner.clean

    @site    = FactoryBot.create(:site)
    @feature = FactoryBot.create(:feature, site: @site)
  end

  it "returns its site" do
    expect(@feature.site).to eq(@site)
  end

  it "accepts many options" do
    @feature.options << FactoryBot.create(:option)
    @feature.options << FactoryBot.create(:option)

    expect(@feature.options.count).to eq(2)
  end

  xit "accepts many child features" do
    child_feature_1 = FactoryBot.create(:feature, site: @site)
    child_feature_2 = FactoryBot.create(:feature, site: @site)
  end

  xit "returns its child features" do
  end

  xit "returns itself as a hash" do 
  end
end
