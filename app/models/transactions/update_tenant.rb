module Transactions
  class UpdateTenant

    include Dry::Transaction(container: ::Registry)

    step :fetch
    step :persist

    private

    def fetch(input, tenant_id:)
      @tenant = Tenants::Tenant.find(tenant_id)

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unabled to find tenant record with id #{tenant_id}"}})
      else
        Success(input)
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