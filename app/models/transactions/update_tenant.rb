module Transactions
  class CreateTenant

    include Dry::Transaction(container: ::Registry)

    step :find_tenant
    step :construct_attributes
    step :validate, with: "resource_registry.tenants.validate"
    step :persist

    private

    def find_tenant(input)
      tenant = Tenants::Tenant.find(input[:tenant_id])
      
      if tenant.blank?
        Failure(input)
      else
        Success(input)
      end
    end

    def construct_attributes(input)
      tenant_params = tenant.to_h.merge(input.to_h)
      
      Success(tenant_params)
    end

    def persist(input)
      tenant = tenant.assign_attributes(input.to_h)
      
      if tenant.save
        Success(tenant)
      else
        Failure(tenant)
      end
    end
  end
end