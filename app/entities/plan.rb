class Plan < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id, Types::String

  attribute :premium_table_ids, Types::Array.of(Types::String)
  attribute :service_area_ids, Types::Array.of(Types::String)

end