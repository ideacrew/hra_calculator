class HraDefaulter < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :state_name,        Types::String
  attribute :counties,          Types::Array.of(Types::String)
  attribute :display_county,    Types::Bool
  attribute :display_zipcode,   Types::Bool
  attribute :start_month_dates, Types::Array.of(Types::String).meta(omittable: true)
  attribute :end_month_dates,   Types::Array.of(Types::String).meta(omittable: true)
  attribute :tax_credit,        Types::String
  attribute :market_place,      Types::String
  attribute :ui_pages,          Types::Array
  attribute :colors,            Types::Array
  attribute :features,          Types::Array
  attribute :pages,             Types::Array
  attribute :translations,      Types::Array
end
