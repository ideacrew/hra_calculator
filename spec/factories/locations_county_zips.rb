FactoryBot.define do
  factory :locations_county_zip, class: '::Locations::CountyZip' do
    county_name { "Hampden" }
    zip { "20024" }
    state { "MA" }
  end
end
