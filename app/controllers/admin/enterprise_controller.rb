class Admin::EnterpriseController < ApplicationController
  
  def show
  end
  
  def account_create
  end

  def tenant_create
    result = Transactions::CreateTenant.new.call(tenant_params)

    redirect_to :show
  end
  
  def tenant_update
    result = Transactions::UpdateTenant.new.call(tenant_params)

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
