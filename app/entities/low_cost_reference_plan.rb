
# Plan designation for State's geographic rating areas
# Subject to change based on question posed to SBEs
class LowCostReferencePlan < Dry::Struct

  # Kinds = [:lowest_cost_silver_plan, :second_lowest_cost_silver_plan]
  # Make an enumerated Type
  attribute :kind, Types::LowCostPlan

  attribute :service_area_ids
  attribute :rating_area_ids

end