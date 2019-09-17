module Validations
  class ProductContract < Dry::Validation::Contract
    params do
      required(:benefit_market_kind).filled(:symbol)
      required(:metal_level_kind).filled(:symbol)
      required(:title).filled(:string)
      required(:hios_id).filled(:string)
      required(:health_plan_kind).filled(:symbol)
      required(:application_period).value(type?: Range)
      required(:service_area_id).value(type?: BSON::ObjectId)
    end
  end
end