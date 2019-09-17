module Transactions
  class DetermineAffordability
    include Dry::Transaction

    step :validate
    step :init_hra_object
    step :find_member_premium
    step :calculate_hra_cost
    step :determine_affordability

    def validate(params)
      result = ::Validations::HraContract.new.call(params)
      if result.failure?
        Failure(result)
      else
        Success(result)
      end
    end

    def init_hra_object(input)
      params = input.to_h
      hra_obj = ::HraAffordabilityDetermination.new(params)
      Success(hra_obj)
    end

    def find_member_premium(hra_obj)
      member_premium = ::Operations::MemberPremium.new.call(hra_obj).success
      Success({hra_obj: hra_obj, premium: member_premium})
    end

    def calculate_hra_cost(hash_obj)
      hra_object = hash_obj[:hra_obj]
      monthly_premium = hash_obj[:premium]
      annual_household_income = ::Operations::AnnualAmount.new.call({frequency: hra_object.household_frequency, amount: hra_object.household_amount})
      annual_hra_amount = ::Operations::AnnualAmount.new.call({frequency: hra_object.hra_frequency, amount: hra_object.hra_amount})
      hra = ((monthly_premium * 12) - annual_hra_amount)/annual_household_income
      Success({hra_obj: hra_obj, hra: hra})
    end

    def determine_affordability(hash_obj)
      hra_cost = hash_obj[:hra]
      expected_contribution = 0.0986 # TODO: read this from the DB.
      result = expected_contribution >= hra_cost ? :unaffordable : :affordable

      Success({result: result, hra_obj: hash_obj[:hra_obj]})
    end
  end
end
