class Plan < Dry::Struct
  transform_keys(&:to_sym)

  attribute :benefit_year_id

  attribute :premium_table_ids
  attribute :service_area_ids

end