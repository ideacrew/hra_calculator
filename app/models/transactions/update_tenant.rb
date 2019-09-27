module Transactions
  class UpdateTenant

    include Dry::Transaction(container: ::Registry)

    step :fetch
    step :persist

    private

    def fetch(input)
      @tenant = Tenants::Tenant.find(input[:id])

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unabled to find tenant record with id #{input[:id]}"}})
      else
        Success(input)
      end
    end

    def validate(input)
      result = super(input)

      if result.success?
        Success(result)
      else
        Failure(result.errors)
      end
    end

    def persist(input)      
      if @tenant.update_attributes(input.to_h)
        Success(tenant)
      else
        Failure(tenant)
      end
    end
  end
end