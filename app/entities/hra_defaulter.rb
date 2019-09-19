class HraDefaulter < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :state_name, Types::String
  attribute :counties, Types::Array.of(Types::String)
  attribute :display_county, Types::Bool
  attribute :display_zipcode, Types::Bool
  attribute :start_month_dates, Types::Array.of(Types::String)
  attribute :end_month_dates, Types::Array.of(Types::String)
end
