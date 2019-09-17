
# Geography where Plans are available
class ServiceArea < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id
  attribute :us_state_id
  attribute :us_county_ids
  attribute :rating_area_ids

end