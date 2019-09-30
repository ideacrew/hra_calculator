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
      @account = Account.where(email: input[:account_email]).first
      if @enterprise.blank?
        Failure({errors: {enterprise_id: "Unabled to find enterprise record with id #{enterprise_id}"}})
      elsif @account.blank?
        Failure({errors: {account_email: "Unabled to find account with id #{input[:account_email]}"}})
      else
        Success(input.slice(:key, :owner_organization_name))
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
        @account.update_attributes!(tenant_id: tenant.id)
        Success(tenant)
      else
        Failure(tenant)
      end
    end
  end
end