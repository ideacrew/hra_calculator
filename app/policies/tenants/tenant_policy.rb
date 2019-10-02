class Tenants::TenantPolicy
  attr_reader :account, :tenant

  def initialize(account, tenant)
    @account = account
    @tenant  = tenant
  end

  def can_modify?
    enterprise_admin? || tenant_admin?
  end

  def tenant_admin?
    tenant.owner_accounts.include? account
  end

  def enterprise_admin?
    tenant.enterprise && tenant.enterprise.owner_account == account
  end
end