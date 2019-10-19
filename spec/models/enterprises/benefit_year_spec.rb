require 'rails_helper'

RSpec.describe Enterprises::BenefitYear, type: :model do

  before(:each) do
    DatabaseCleaner.clean

    @enterprise   = FactoryBot.create(:enterprise)
    @benefit_year = FactoryBot.create(:benefit_year, enterprise: @enterprise)
  end

  it "is valid with a valid expected contribution amount" do
    @benefit_year.expected_contribution = 1
    expect(@benefit_year).to_not be_valid

    @benefit_year.expected_contribution = 0
    expect(@benefit_year).to_not be_valid

    @benefit_year.expected_contribution = "0.5".to_f
    expect(@benefit_year).to be_valid
  end

  it "must have a valid enterprise" do
    benefit_year = FactoryBot.build(:benefit_year, expected_contribution: "0.5".to_f)
    expect(benefit_year).to_not be_valid
  end

  it "returns its enterprise" do
    expect(@benefit_year.enterprise).to eq(@enterprise)
  end

end
