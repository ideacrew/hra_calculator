require 'rails_helper'
require 'shared_contexts/tenant_hash'

RSpec.describe Options::Option, type: :model do

  before(:each) do
    DatabaseCleaner.clean
    @option = FactoryBot.create(:option)
  end

  it "accepts multiple child options" do
    @option.child_options.push(FactoryBot.create(:option), FactoryBot.create(:option))
    expect(@option.options.count).to eq(2)
  end

  context "with nested options" do
    let(:option_1) do
      FactoryBot.create(:option,
        :key=>:use_age_ratings,
        :title=>"Use Age Ratings?",
        :type=>:radio_select,
        :description=>"Choose whether your organization uses the member's age to determine health insurance premium rates.  If Yes, the Tool will collect the users date-of-birth to calculate premiums.",
        :default=>:yes,
        :namespace=>false)
    end
    let(:option_2) do
      FactoryBot.create(:option,
       :key=>:qsehra_premium_factor,
       :title=>"Premium Value Used for QSEHRA Comparison",
       :description=>"QSEHRA determinations can use either the Second Lowest Cost Silver Plan's full premium or Essential Health Benefits value",
       :default=>:full,
       :type=>:radio_select,
       :namespace=>false)
    end
    let(:option_3) do
      FactoryBot.create(:option,
       :key=>:rating_area_model,
       :title=>"Geographic Rating Area Model",
       :default=>"nil",
       :type=>:radio_select,
       :description=>
        "Choose boundaries that your organization uses to determine health insurance premium rates.  Single Rating Area requires SERFF template uploads only and will not ask the user for home residence information.  County- and Zipcode-based Rating Areas require SERFF templates plus County/Zip lookup table uploads and request the user enter county name and zip code as appropriate to calculate premiums.",
       :namespace=>true)
    end

    it "reads settings of child options" do
      @option.child_options.push(option_1,option_2,option_3)

      expect(@option.child_options.first.setting_hash[:title]).to eq("Use Age Ratings?")

      expect(@option.namespaces.count).to eq(1)
      expect(@option.namespaces.first[:title]).to eq("Geographic Rating Area Model")

      expect(@option.settings.count).to eq(3)
      expect(@option.settings.first[:title]).to eq("Use Age Ratings?")
    end
  end
end
