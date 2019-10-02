class Enterprises::EnterprisePolicy
  attr_reader :account, :enterprise

  def initialize(account, enterprise)
    @account    = account
    @enterprise = enterprise
  end

  def can_modify?
    enterprise.owner_account && enterprise.owner_account == account
  end
end