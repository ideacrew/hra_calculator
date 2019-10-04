FactoryBot.define do
  factory :benefit_year, class: '::Enterprises::BenefitYear' do

    # belongs_to enterprise
    expected_contribution { "0.5".to_f }
  end
end
