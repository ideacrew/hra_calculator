class Admin::TenantsController < ApplicationController
  layout 'admin'

  def show
    @tenant = Tenants::Tenant.find(params[:id])
  end

  def update
    result = Transactions::UpdateTenant.new.call({id: params[:id], tenant: tenant_params})
    tenant = result.value!

    if result.success?
      flash[:notice] = 'Successfully updated marketplace settings'
    else
      flash[:error]  = 'Something went wrong.'
    end

    redirect_to action: :show, id: tenant.id
  end

  def upload_logo
  end

  def features_show
    @tenant = Tenants::Tenant.find(params[:tenant_id])
  end
  
  def features_update
    result = Transactions::UpdateTenant.new.call({id: params[:tenant_id], tenant: tenant_params})
    tenant = result.value!

    if result.success?
      flash[:notice] = 'Successfully updated marketplace settings'
    else
      flash[:error]  = 'Something went wrong.'
    end

    redirect_to action: :features_show, id: tenant.id
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

  def tenant_params
    params.require(:tenants_tenant).permit(
      :owner_organization_name,
      sites_attributes: [
        :id,
        options_attributes: [
          :id, :value,
          child_options_attributes: [
            :id, :value,
            child_options_attributes: [:id, :value]
          ]
        ],
        features_attributes: [ 
          :id,
          options_attributes: [
            :id, :value,
            child_options_attributes: [
              :id, :value,
              child_options_attributes: [:id, :value]
            ]
          ]
        ]
      ]
    )
  end
end
