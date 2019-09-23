class Employer < Dry::Struct
  transform_keys(&:to_sym)

  attribute :county, Types::String
  attribute :state, Types::String
  attribute :zip_code, Types::String

end