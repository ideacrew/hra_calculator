class HraAffordabilityDetermination < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :state, Types::String
  attribute :zipcode, Types::String.default(''.freeze)
  attribute :county, Types::String.default(''.freeze)
  attribute :dob, Types::Date
  attribute :household_frequency, Types::String # 'monthly' or 'annually'
  attribute :household_amount, Types::Float
  attribute :hra_type, Types::String # :ichra or :qsehra
  attribute :start_month, Types::Date
  attribute :end_month, Types::Date
  attribute :hra_frequency, Types::String # 'monthly' or 'annually'
  attribute :hra_amount, Types::Float

  attribute :member_premium, Types::Float.default(0.00.freeze)
  attribute :age, Types::Integer.default(0.freeze)
  attribute :hra, Types::Float.default(0.00.freeze)
  attribute :hra_determination, Types::String.default('No Determination'.freeze)
  attribute :rating_area_id, Types::String.meta(omittable: true)
  attribute :service_area_ids, Types::Array.of(Types::String).meta(omittable: true)
  attribute :errors, Types::Array.default([])
end
