class Admin::TenantsController < ApplicationController
  layout 'admin'

  def show
    @tenant = Tenants::Tenant.find(params[:id])
  end

  def update
    result = Transactions::UpdateTenant.new.call(tenant_params)

    redirect_to :show
  end

  def upload_logo
  end

  def features_show
  end
  
  def features_update
  end
  
  def ui_pages_show
  end
  
  def ui_element_update
  end
  
  def plan_index
  end
  
  def upload_plan_data
  end
  
  def zip_county_data
  end
end
