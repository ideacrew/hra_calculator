class UsCounty < Dry::Struct
  transform_keys(&:to_sym)

end