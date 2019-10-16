# frozen_string_literal: true

module Transactions
  class DetermineAffordability
    include Dry::Transaction

    step :validate
    step :init_entities
    step :fetch_rating_area
    step :filter_plans
    step :filter_premium
    step :calculate_benefit
    step :compare_benefit
    step :init_hra_affordability
    step :load_results_defaulter

    def validate(params)
      output = ::Validations::HraContract.new.call(params)
      if output.failure?
        result = output.to_h
        result[:errors] = []
        output.errors.to_h.each_pair do |keyy, val|
          result[:errors] << "#{keyy.to_s} #{val.first}"
        end
        Failure(result)
      else
        Success(output.to_h)
      end
    end

    def init_entities(params)
      benefit_year_obj = ::Enterprises::BenefitYear.where(calendar_year: params[:start_month].year).first
      return Failure(params.merge!({errors: ["Unable to find BenefitYear object for given start_month date: #{params[:start_month]}"]})) unless benefit_year_obj

      @tenant = ::Tenant.new({key: params[:tenant], name: params[:state]})
      @benefit_year = ::BenefitYear.new({expected_contribution: benefit_year_obj.expected_contribution, calendar_year: benefit_year_obj.calendar_year})
      Success(params.to_h.merge!({errors: []}))
    end

    def fetch_rating_area(params)
      rating_area_result = ::Locations::Transactions::SearchForRatingArea.new.call(params)

      if rating_area_result.success?
        Success(params.merge!({rating_area_id: rating_area_result.success}))
      else
        Failure(params.merge!(rating_area_result.failure))
      end
    end

    def filter_plans(params)
      fetch_products_result = ::Products::Transactions::FetchProducts.new.call(params)

      if fetch_products_result.success?
        Success(params.merge!({plans_query_criteria: fetch_products_result.success}))
      else
        Failure(params.merge!(fetch_products_result.failure))
      end
    end

    def filter_premium(params)
      lcrp_result = ::Products::Transactions::LowCostReferencePlanCost.new.call(params)
      return Failure(params.merge!(lcrp_result.failure)) if lcrp_result.failure?

      params = lcrp_result.success
      @member = ::Member.new({date_of_birth: params[:dob], age: params[:age],
                              gross_income: params[:household_amount], income_frequency: params[:household_frequency],
                              county: params[:county], zipcode: params[:zipcode], premium_age: params[:premium_age],
                              premium_amount: params[:member_premium]})
      @low_cost_reference_plan = ::LowCostReferencePlan.new({kind: params[:plan_kind], plan_name: params[:plan_name],
                                                             hios_id: params[:hios_id], carrier_name: params[:carrier_name],
                                                             service_area_ids: params[:service_area_ids], rating_area_id: params[:rating_area_id]})
      Success(params)
    end

    def calculate_benefit(params)
      calculate_benefit_result = ::Transactions::CalculateBenefit.new.call(params)

      if calculate_benefit_result.success?
        Success(params.merge!({hra: calculate_benefit_result.success}))
      else
        Failure(params.merge!(calculate_benefit_result.failure))
      end
    end

    def compare_benefit(params)
      hra_determination = @benefit_year.expected_contribution >= params[:hra] ? :affordable : :unaffordable
      @hra = ::Hra.new({cost: params[:hra], kind: params[:hra_type], effective_start_date: params[:start_month], effective_end_date: params[:end_month], reimburse_amount: params[:hra_amount], reimburse_frequency: params[:hra_frequency], determination: hra_determination})
      Success(params.merge!({hra_determination: hra_determination}))
    end

    def init_hra_affordability(params)
      @hra_affordability = ::HraAffordabilityDetermination.new({benefit_year: @benefit_year, tenant: @tenant, member: @member, low_cost_reference_plan: @low_cost_reference_plan, hra: @hra})
      Success(params)
    end

    def load_results_defaulter(params)
      hra_results_setter = ::Operations::HraDefaultResultsSetter.new.call(@tenant.key)
      params.merge!(hra_results_setter.success.to_h)
      Success(params)
    end
  end
end
