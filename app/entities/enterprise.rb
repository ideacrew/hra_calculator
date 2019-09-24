class Enterprise < Dry::Struct
  include DryStructSetters
  transform_keys(&:to_sym)

  attribute :owner_account_id,        Types::String
  attribute :owner_organization_name, Types::String.meta(omittable: true) 
  attribute :tenants,                 Types::Array.of(Tenant).meta(omittable: true) 
end