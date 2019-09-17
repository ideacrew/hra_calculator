class UsState < Dry::Struct
  transform_keys(&:to_sym)

  attribute :name # Maryland
  attribute :usps_abbrevation # MD

end