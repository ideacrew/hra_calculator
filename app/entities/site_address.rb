class SiteAddress < Dry::Struct

  # Use Dry-Validation contract with macros to do conditional validation

  # these are optional values
  attribute :address_1
  attribute :address_2

  # county is necessary to disambiguate if zip code is in more that one county
  attribute :county

  # these are required values
  attribute :state
  attribute :zip_code
end