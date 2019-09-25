class Member < Dry::Struct
  transform_keys(&:to_sym)

  attribute :date_of_birth, Types::Date
  attribute :gross_income, Types::Float
  attribute :income_year, Types::Integer
  attribute :site_address, Types::String
  attribute :email, Types::String
end
