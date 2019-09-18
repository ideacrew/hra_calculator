module Transactions
  class DetermineAffordability
    include Dry::Transaction

    step :validate
    step :init_hra_object
    step :find_member_premium
    step :calculate_hra_cost
    step :determine_affordability

    def validate(params)
      output = ::Validations::HraContract.new.call(params)
      if output.failure?
        Failure(output)
      else
        Success(output)
      end
    end

    def init_hra_object(input)
      params = input.to_h
      hra_obj = ::Operations::InitializeHra.new.call(params).success
      Success(hra_obj)
    end

    def find_member_premium(hra_obj)
      hra_obj.member_premium = ::Operations::MemberPremium.new.call(hra_obj).success
      Success(hra_obj)
    end

    def calculate_hra_cost(hra_object)
      annual_household_income = ::Operations::AnnualAmount.new.call({frequency: hra_object.household_frequency, amount: hra_object.household_amount})
      annual_hra_amount = ::Operations::AnnualAmount.new.call({frequency: hra_object.hra_frequency, amount: hra_object.hra_amount})
      hra_object.hra = begin
                         ((hra_object.member_premium * 12) - annual_hra_amount)/annual_household_income
                       rescue => e
                         hra_object.errors << 'Could Not calculate hra for the given data'
                         return Failure(hra_object)
                       end
      Success(hra_object)
    end

    def determine_affordability(hra_object)
      expected_contribution = 0.0986 # TODO: read this from the DB/Settings
      hra_object.hra_determination = expected_contribution >= hra_object.hra ? :unaffordable : :affordable
      Success(hra_object)
    end
  end
end
