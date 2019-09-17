# Geography within a Service Area where premium rates may be assigned
class RatingArea < Dry::Struct
  transform_keys(&:to_sym)

  attribute :rating_area_id

  attribute :benefit_year_id
  attribute :service_area_id
  attribute :county_ids
  attribute :zip_code_ids

end