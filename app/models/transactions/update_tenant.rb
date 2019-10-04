module Transactions
  class UpdateTenant

    include Dry::Transaction(container: ::Registry)

    step :fetch
    step :persist

    private

    def fetch(input)
      @tenant = input[:tenant]

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unabled to find tenant record with id #{input[:id]}"}})
      else
        Success(input[:tenant_params])
      end
    end

    def persist(input)
      if @tenant.update_attributes(input.to_h)
        Success(@tenant)
      else
        Failure(@tenant)
      end
    end
  end
end