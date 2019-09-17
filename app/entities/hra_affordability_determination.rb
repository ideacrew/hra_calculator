class HraAffordabilityDetermination < Dry::Struct
  transform_keys(&:to_sym)

  attribute :state, Types::String
  attribute :zipcode, Types::Integer
  attribute :county, Types::String
  attribute :dob, Types::Date
  attribute :household_frequency, Types::String
  attribute :household_amount, Types::Float
  attribute :hra_type, Types::String
  attribute :start_month, Types::Date
  attribute :end_month, Types::Date
  attribute :hra_frequency, Types::String
  attribute :hra_amount, Types::Float

  # attribute :member_premium, Types::Float, default: 0.00
  # attribute :age, Types::Integer, default: 0
  # attribute :hra, Types::Float, default: 0.00
end
