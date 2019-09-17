class Employer < Dry::Struct
  transform_keys(&:to_sym)

  attribute :county
  attribute :state
  attribute :zip_code

end