# frozen_string_literal: true

module Transactions
  class CalculateBenefit
    include Dry::Transaction

    step :annual_household_income
    step :annual_hra_amount
    step :hra_cost

    private

    def annual_household_income(params)
      annual_household_income = ::Operations::AnnualAmount.new.call({frequency: params[:household_frequency], amount: params[:household_amount]}).success
      params.merge!({annual_household_income: annual_household_income})
      Success(params)
    end

    def annual_hra_amount(params)
      annual_hra_amount = ::Operations::AnnualAmount.new.call({frequency: params[:hra_frequency], amount: params[:hra_amount]}).success
      params.merge!({annual_hra_amount: annual_hra_amount})
      Success(params)
    end

    def hra_cost(params)
      begin
        Success(((params[:member_premium] * 12) - params[:annual_hra_amount])/params[:annual_household_income])
      rescue => e
        return Failure({errors: ['Could Not calculate hra cost for the given data']})
      end
    end
  end
end
