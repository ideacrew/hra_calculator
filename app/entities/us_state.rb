class UsState < Dry::Struct
  transform_keys(&:to_sym)

  attribute :name, Types::String # Maryland
  attribute :usps_abbrevation, Types::String # MD

end