FactoryBot.define do
  factory :locations_rating_area, class: '::Locations::RatingArea' do
    active_year { Date.today.year }
    exchange_provided_code { "R-DC001" }
    covered_states { [Registry['enterprise.dchbx.primary.production.state_abbr']] }
    county_zip_ids { [create(:locations_county_zip, county_name: 'Middlesex', zip: '20024', state: Registry['enterprise.dchbx.primary.production.state_abbr']).id] }
  end
end
