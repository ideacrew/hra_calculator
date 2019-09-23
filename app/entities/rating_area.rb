# Geography within a Service Area where premium rates may be assigned
class RatingArea < Dry::Struct
  transform_keys(&:to_sym)

  attribute :rating_area_id, Types::String

  attribute :benefit_year_id, Types::String
  attribute :service_area_id, Types::String
  attribute :county_ids, Types::String
  attribute :zip_code_ids, Types::Array.of(Types::String)

end