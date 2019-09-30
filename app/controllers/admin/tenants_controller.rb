class Admin::TenantsController < ApplicationController
  layout 'admin'

  before_action :find_tenant, only: [:show, :features_show, :ui_pages_show, :plan_index]

  def show
  end

  def update
    result = Transactions::UpdateTenant.new.call({id: params[:id], tenant: tenant_params})
    tenant = result.value!

    if result.success?
      flash[:notice] = 'Successfully updated marketplace settings'
    else
      flash[:error]  = 'Something went wrong.'
    end

    redirect_to admin_tenant_path(id: tenant.id, tab_name: params[:id]+"_profile")
  end

  def upload_logo
  end

  def features_show
  end

  def features_update
    result = Transactions::UpdateTenant.new.call({id: params[:tenant_id], tenant: tenant_params})
    tenant = result.value!

    if result.success?
      flash[:notice] = 'Successfully updated marketplace settings'
    else
      flash[:error]  = 'Something went wrong.'
    end

    redirect_to action: :features_show, id: params[:tenant_id], tab_name: params[:tenant_id]+"_features"
  end

  def ui_pages_show
    @page = @tenant.sites[0].options.where(key: :ui_tool_pages).first
  end

  def ui_element_update
    result = Transactions::UpdateUiElement.new.call({tenant_id: ui_element_params[:tenant_id], ui_element: ui_element_params.slice(:option_id, :option)})
    ui_element = result.value!
    if result.success?
      flash[:notice] = 'Successfully updated page settings'
    else
      flash[:error]  = 'Something went wrong.'
    end

    render :js => "window.location = #{admin_tenant_path(ui_element_params[:tenant_id]).to_json}"
  end

  def ui_pages_edit
    @tenant = Tenants::Tenant.find(params[:tenant_id])
    @option = @tenant.sites[0].options.where(key: :ui_tool_pages).first.options.find(params[:option_id])

    # redirect_to action: :ui_pages_show, id: params[:tenant_id], tab_name: params[:tenant_id]+"_ui_pages"
  end

  def plan_index
    @tenant = ::Tenants::Tenant.find(params.permit!['tenant_id'])
    @products = ::Products::HealthProduct.all
    @years = [2020, 2021]
  end

  def upload_plan_data
    params.permit!
    result = Transactions::SerffTemplateUpload.new.call(params.to_h)
    if result.success?
      flash[:notice] = 'Successfully uploaded plans'
    else
      flash[:error] = result.failure[:errors].first
    end

    redirect_to admin_tenant_plan_index_path(params[:tenant_id], tab_name: params[:tenant_id]+"_plans")
  end

  def zip_county_data
    params.permit!
    result = Transactions::CountyZipFile.new.call(params.to_h)

    if result.success?
      redirect_to admin_tenant_plan_index_path(params[:tenant_id], tab_name: params[:tenant_id]+"_plans")
    else
      result.failure
      # display errors on the same page
    end
  end

  def plans_destroy
    result = ::Transactions::PlansDestroy.new.call(params)

    if result.success?
      flash[:notice] = 'Successfully destroyed plans'
      redirect_to admin_tenant_plan_index_path(params[:id], tab_name: params[:id]+"_plans")
    else
      result.failure
      # display errors on the same page
    end
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

  def ui_element_params
    params.permit!
    params.to_h
  end

  def find_tenant
    tenant_id = params[:tenant_id] || params[:id]
    @tenant = Tenants::Tenant.find(tenant_id)
    @enterprise = @tenant.enterprise
  end
end
