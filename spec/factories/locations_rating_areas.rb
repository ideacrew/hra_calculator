FactoryBot.define do
  factory :locations_rating_area, class: '::Locations::RatingArea' do
    active_year { Date.today.year }
    exchange_provided_code { 'Rating Area 1' }
    county_zip_ids { [create(:locations_county_zip, county_name: 'Middlesex', zip: '20024', state: 'MA').id] }
  end
end
