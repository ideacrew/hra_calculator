class Admin::EnterpriseController < ApplicationController
  layout 'admin'

  def show
    @enterprise = ::Enterprises::Enterprise.first
    @accounts = Account.all
    @states = Locations::UsState::NAME_IDS.map(&:first)
    # @benefit_years = @enterprise.benefit_years
    # @tenants = @enterprise.tenants
  end

  def account_create
    create_tenant = Transactions::CreateAccount.new
    result = create_tenant.call(account_create_params)

    redirect_to :show
  end

  def tenant_create
    create_tenant = Transactions::CreateTenant.new
    result = create_tenant.with_step_args(fetch: [enterprise_id: ::Enterprises::Enterprise.first.id]).call(tenant_params)

    redirect_to :show
  end

  def benefit_year_create
  end

  def benefit_year_update
  end

  private

  def account_create_params
    params.permit!
    params.to_h
    # {:email=>"asjdb@jhbs.com"}
  end

  # filter tenant params
  def tenant_params
    # tenant_params = {key: :dc, owner_organization_name: 'DC Marketplace'}
    params.permit!
    params.to_h
  end
end
