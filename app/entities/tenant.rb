class Tenant < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :key,               Types::Symbol
  attribute :name,              Types::String
  attribute :alias,             Types::String.meta(omittable: true)  # => "Marketplace"
end
