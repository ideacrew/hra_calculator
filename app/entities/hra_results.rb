class HraResults < Dry::Struct
  transform_keys(&:to_sym)

  attribute :colors, Types::Array  
end
