class HeaderFooterConfiguration < Dry::Struct
  include ::DryStructSetters
  transform_keys(&:to_sym)

  attribute :tenant_logo_file, Types::String
  attribute :tenant_url, Types::String
  attribute :customer_support_number, Types::String
  attribute :benefit_year, Types::Integer
end
