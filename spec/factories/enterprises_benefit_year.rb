# frozen_string_literal: true

FactoryBot.define do
  factory :benefit_year, class: '::Enterprises::BenefitYear' do
    expected_contribution { 0.976 }
    calendar_year         { 2020 }
    description           { 'BenefitYear for 2020' }
  end
end
