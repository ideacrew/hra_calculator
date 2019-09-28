module Validations
  class BenefitYearContract < ::Dry::Validation::Contract
    params do
      required(:expected_contribution).filled(:float)
      required(:calendar_year).filled(:integer)
    end
    # TODO: Add additional rules for expected_contribution and calendar_year
  end
end
