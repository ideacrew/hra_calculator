
# Geography where Plans are available
class ServiceArea < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id, Types::String
  attribute :us_state_id, Types::String
  attribute :us_county_ids, Types::Array.of(Types::String)
  attribute :rating_area_ids, Types::Array.of(Types::String)

end