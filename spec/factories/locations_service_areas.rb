FactoryBot.define do
  factory :locations_service_area, class: '::Locations::ServiceArea' do
    active_year { Date.today.year }
    issuer_provided_code { "MAS001" }
    covered_states { ['MA'] }
  end
end
