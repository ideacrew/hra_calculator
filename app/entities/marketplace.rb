class Tenant < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :key,               Types::Symbol
  attribute :alias,             Types::String # => "Marketplace"
  attribute :name,              Types::String
  attribute :owner_account_ids, Types::Array.of(Types::String)
end