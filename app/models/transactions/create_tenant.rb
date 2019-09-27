module Transactions
  class CreateTenant

    include Dry::Transaction(container: ::Registry)

    step :construct_attributes
    step :validate, with: "resource_registry.tenants.validate"
    step :persist

    private

    def construct_attributes(input)
      tenant_attributes = tenant_configurations.merge(input)
      
      Success(tenant_attributes)
    end

    def validate(input)
      result = super(input)

      if result.success?
        Success(result)
      else
        Failure(result.errors)
      end
    end

    def persist(input, enterprise_id:)
      tenant = Tenants::Tenant.new(input.to_h)
      tenant.enterprise_id = enterprise_id
      
      if tenant.save
        Success(tenant)
      else
        Failure(tenant)
      end
    end

    def tenant_configurations
      ResourceRegistry::AppSettings[:tenants].first
    end
  end
end