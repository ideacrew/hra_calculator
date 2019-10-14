class Member < Dry::Struct
  transform_keys(&:to_sym)

  attribute :date_of_birth, Types::Date
  attribute :age, Types::Integer
  attribute :gross_income, Types::Float
  attribute :income_frequency, Types::String
  attribute :county, Types::String
  attribute :zipcode, Types::String
  attribute :premium_age, Types::Integer
  attribute :premium_amount, Types::Float
end
