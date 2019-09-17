class ZipCode < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id

end