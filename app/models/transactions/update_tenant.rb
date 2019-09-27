module Transactions
  class UpdateTenant

    include Dry::Transaction(container: ::Registry)

    step :fetch
    step :construct_attributes
    step :validate, with: "resource_registry.tenants.validate"
    step :persist

    private

    def fetch(input, tenant_id:)
      @tenant = Tenants::Tenant.find(tenant_id)

      if @tenant.blank?
        Failure({errors: {enterprise_id: "Unabled to find tenant record with id #{tenant_id}"}})
      else
        Success(input)
      end
    end

    def construct_attributes(input)
      tenant_params = @tenant.to_h.merge(input.to_h)
      
      Success(tenant_params)
    end

    def persist(input)
      tenant = @tenant.assign_attributes(input.to_h)
      
      if tenant.save
        Success(tenant)
      else
        Failure(tenant)
      end
    end
  end
end