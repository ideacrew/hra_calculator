# Plan designation for State's geographic rating areas
# Subject to change based on question posed to SBEs
class LowCostReferencePlan < Dry::Struct
  Kinds = [:lowest_cost_silver_plan, :second_lowest_cost_silver_plan]

  # Make an enumerated Type
  attribute :kind, Types::Symbol
  attribute :plan_name, Types::String
  attribute :hios_id, Types::String
  attribute :carrier_name, Types::String
  attribute :service_area_ids, Types::Array.of(Types::String)
  attribute :rating_area_id, Types::String
  # attribute :premium_amount, Types::Float
end
