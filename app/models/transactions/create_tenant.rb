module Transactions
  class CreateTenant

    include Dry::Transaction(container: ::Registry)

    step :construct_attributes
    step :validate, with: "resource_registry.tenants.validate"
    step :persist

    private

    def construct_attributes(input)
      # binding.pry
      tenant_attributes = tenant_configurations.merge(input)

      Success(tenant_attributes)
    end

    def persist(input)
      tenant = Tenants::Tenant.new(input.to_h)
      
      if tenant.save
        Success(tenant)
      else
        Failure(tenant)
      end
    end

    def tenant_configurations

    end
  end
end