module Transactions
  class ImportSerffFiles
    include Dry::Transaction

    step :validate_and_assign
    step :process_service_area
    step :process_plans
    step :process_rates

    private

    def validate_and_assign(input_params)
      @sa_file = input_params[:service_area_file]
      @plans_file = input_params[:plans_file]
      @rates_file = input_params[:rates_file]
      @import_timestamp = input_params[:import_timestamp]
      @tenant = input_params[:tenant]
      @year = input_params[:year]
      @carrier_name = input_params[:carrier_name]

      Success(@sa_file)
    end

    def process_service_area(input)
      return Success(@plans_file) if (@tenant.geographic_rating_model == :single_rating_area)

      sa_params = { sa_file: input, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
      import_sa = ::Operations::ImportServiceArea.new.call(sa_params)

      if import_sa.failure?
        Failure("Failed to store data from file #{File.basename(sa_params[:sa_file])}")
      else
        Success(success_hash)
      end
    end

    def process_plans(input)
      plan_params = { plans_file: input, tenant: @tenant, year: @year, import_timestamp: @import_timestamp, carrier_name: @carrier_name }
      import_plans = ::Operations::CreatePlan.new.call(plan_params)

      if import_plans.failure?
        Failure("Failed to store data from file #{File.basename(plan_params[:plans_file])}")
      else
        Success(@rates_file)
      end
    end

    def process_rates(input)
      return Success("Loaded Plans for tenant #{@tenant.key}") unless @tenant.use_age_ratings?

      rate_params = { rates_file: input, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
      rates_result = ::Operations::CreateRates.new.call(rate_params)

      if rates_result.failure?
        Failure("Failed to store data from file #{File.basename(input)}")
      else
        Success("Imported rates for carrier #{@carrier_name}")
      end
    end
  end
end
