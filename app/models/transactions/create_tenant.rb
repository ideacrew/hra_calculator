module Transactions
  class CreateTenant

    include Dry::Transaction(container: ::Registry)

    step :fetch
    step :construct_attributes
    step :validate, with: "resource_registry.tenants.validate"
    step :persist

    private

    def fetch(input, enterprise_id:)
      @enterprise = Enterprises::Enterprise.find(enterprise_id)
      
      if @enterprise.blank?
        Failure({errors: {enterprise_id: "Unabled to find enterprise record with id #{enterprise_id}"}})
      else
        Success(input)
      end
    end

    def construct_attributes(input)
      tenant_settings   = ResourceRegistry::AppSettings[:tenants][0]
      tenant_attributes = tenant_settings.merge(input)
      
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

    def persist(input)
      tenant = Tenants::Tenant.new(input.to_h)
      tenant.enterprise_id = @enterprise.id
      
      if tenant.save
        Success(tenant)
      else
        Failure(tenant)
      end
    end
  end
end