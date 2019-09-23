class SiteAddress < Dry::Struct

  # Use Dry-Validation contract with macros to do conditional validation

  # these are optional values
  attribute :address_1, Types::String
  attribute :address_2, Types::String

  # county is necessary to disambiguate if zip code is in more that one county
  attribute :county, Types::String

  # these are required values
  attribute :state, Types::String
  attribute :zip_code, Types::Integer
end