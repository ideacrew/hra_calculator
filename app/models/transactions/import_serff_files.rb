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
      return Success(@plans_file) if (@tenant.geographic_rating_area_model == 'single')

      begin
        sa_params = { sa_file: input, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
        import_sa = ::Operations::ImportServiceArea.new.call(sa_params)
        return Failure({errors: ["Failed to store data from file #{File.basename(sa_params[:sa_file])}"]}) if import_sa.failure?

        Success(@plans_file)
      rescue
        return Failure({errors: ["Failed to fetch service area data for carrier: #{@carrier_name}"]}) if input.nil?
        Failure({errors: ["Failed to store data from file #{File.basename(input)}"]})
      end
    end

    def process_plans(input)
      begin
        plan_params = { plans_file: input, tenant: @tenant, year: @year, import_timestamp: @import_timestamp, carrier_name: @carrier_name }
        import_plans = ::Operations::CreatePlan.new.call(plan_params)
        return Failure("Failed to store data from file #{File.basename(input)}") if import_plans.failure?

        Success(@rates_file)
      rescue
        return Failure({errors: ["Failed to fetch plans data for carrier: #{@carrier_name}"]}) if input.nil?
        Failure({errors: ["Failed to store data from file #{File.basename(input)}"]})
      end
    end

    def process_rates(input)
      begin
        rate_params = { rates_file: input, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
        rates_result = ::Operations::CreateRates.new.call(rate_params)
        return Failure({errors: ["Failed to store data from file #{File.basename(input)}"]}) if rates_result.failure?

        Success("Imported rates for carrier #{@carrier_name}")
      rescue
        return Failure({errors: ["Failed to fetch rates data for carrier: #{@carrier_name}"]}) if input.nil?
        Failure({errors: ["Failed to store data from file #{File.basename(input)}"]})
      end
    end
  end
end
