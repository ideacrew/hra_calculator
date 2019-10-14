# frozen_string_literal: true

module Transactions
  class DetermineAffordability
    include Dry::Transaction

    # init_benefit_year BenefitYear: expected_contribution, calendar_year(start_month, year)
    # init_benefit_year Tenant: key(tenant), name(state)
    # filter_premium Member: date_of_birth(dob), age(age), gross_income(household_amount), income_frequency(household_frequency), county(county), zipcode(zipcode), premium_age(age_lookup), premium_amount(member_premium)
    # filter_premium LowCostReferencePlan: plan_name(plan_name), hios_id(hios_id), carrier_name(carrier_name), service_area_ids(service_area_ids), rating_area_id(rating_area_id)
    # compare_benefit Hra: cost(hra), kind(hra_type), effective_start_date(start_month), effective_end_date(end_month), reimburse_amount(hra_amount), reimburse_frequency(hra_frequency), determination(hra_determination)

    step :validate
    step :init_benefit_year
    step :fetch_rating_area
    step :filter_plans
    step :filter_premium
    step :calculate_benefit
    step :compare_benefit
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
        Success(output)
      end
    end

    def init_benefit_year(params)
      benefit_year_obj = ::Enterprises::BenefitYear.where(calendar_year: params[:start_month].year).first
      return Failure(params.merge!({errors: ["Unable to find BenefitYear object for given start_month date: #{params[:start_month]}"]})) unless benefit_year_obj

      @benefit_year = ::BenefitYear.new({expected_contribution: benefit_year_obj.expected_contribution, calendar_year: benefit_year_obj.calendar_year})
      Success(params.to_h.merge!({errors: []}))
    end

    def fetch_rating_area(params)
      params = params.to_h
      rating_area_result = ::Locations::Operations::SearchForRatingArea.new.call(params)

      if rating_area_result.success?
        Success(params.merge!({rating_area_id: rating_area_result.success}))
      else
        Failure(params.merge!(rating_area_result.failure))
      end
    end

    def filter_plans(params)
      params = params.to_h
      fetch_products_result = ::Products::Transactions::FetchProducts.new.call(params)

      if fetch_products_result.success?
        Success(params.merge!({plans_query_criteria: fetch_products_result.success}))
      else
        Failure(params.merge!(fetch_products_result.failure))
      end
    end

    def filter_premium(params)
      params = params.to_h
      lcrp_result = ::Products::Operations::LowCostReferencePlanCost.new.call(params)
      return Failure(params.merge!(lcrp_result.failure)) if lcrp_result.failure?

      sucess_res = lcrp_result.success
      params.merge!({member_premium: sucess_res.first,
                     carrier_name: sucess_res[1],
                     hios_id: sucess_res[2],
                     plan_name: sucess_res[3]})
      Success(params)
    end

    def calculate_benefit(params)
      params = params.to_h
      calculate_benefit_result = ::Transactions::CalculateBenefit.new.call(params)

      if calculate_benefit_result.success?
        Success(params.merge!({hra: calculate_benefit_result.success}))
      else
        Failure(params.merge!(calculate_benefit_result.failure))
      end
    end

    def compare_benefit(params)
      params = params.to_h
      hra_determination = @benefit_year.expected_contribution >= params[:hra] ? :affordable : :unaffordable
      Success(params.merge!({hra_determination: hra_determination}))
    end

    def load_results_defaulter(params)
      params = params.to_h
      hra_results_setter = ::Operations::HraDefaultResultsSetter.new.call(params[:tenant])
      params.merge!(hra_results_setter.success.to_h)
      Success(params)
    end
  end
end
