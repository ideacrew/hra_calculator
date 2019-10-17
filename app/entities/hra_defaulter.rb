class HraDefaulter < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :state_name, Types::String
  attribute :counties, Types::Array.of(Types::String)
  attribute :display_county, Types::Bool
  attribute :display_zipcode, Types::Bool
  attribute :tax_credit, Types::String
  attribute :market_place, Types::String
  attribute :ui_pages, Types::Array
  attribute :colors,   Types::Array
  attribute :features,   Types::Array
end
