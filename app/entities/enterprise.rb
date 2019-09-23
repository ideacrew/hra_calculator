class Enterprise < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :owner_organization_name, Types::String
  attribute :owner_account_id,        Types::String
end