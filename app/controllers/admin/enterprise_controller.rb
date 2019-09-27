class Admin::EnterpriseController < ApplicationController
  layout 'admin'
  
  def show
  end
  
  def account_create
  end

  def tenant_create
    create_tenant = Transactions::CreateTenant.new
    result = create_tenant
                .with_step_args(persist: [enterprise_id: Enterprises::Enterprise.first.id])
                .call(key: :dc, owner_organization_name: 'DC Marketplace')

    redirect_to :show
  end
  
  def benefit_year_create
  end
  
  def benefit_year_update
  end

  private

  # filter tenant params
  def tenant_params
    params
  end
end
