module Validations
  class PremiumTableContract < Dry::Validation::Contract
    params do
      required(:effective_period).value(type?: Range)
      required(:rating_area_id).value(type?: BSON::ObjectId)
      required(:premium_tuples).array(:hash) do
        required(:cost).value(:float)
        required(:age).value(:integer)
      end
    end
  end
end