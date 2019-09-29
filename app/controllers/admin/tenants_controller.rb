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
    @tenant = Tenants::Tenant.find(params[:tenant_id])
    @page = @tenant.sites[0].options.where(key: :ui_tool_pages).first
  end

  def ui_element_update
    result = Transactions::UpdateUiElement.new.call({tenant_id: params[:tenant_id], ui_element: ui_element_params})
    ui_element = result.value!
    if result.success?
      flash[:notice] = 'Successfully updated page settings'
    else
      flash[:error]  = 'Something went wrong.'
    end

    redirect_to action: :show, id: params[:tenant_id]
  end

  def plan_index
    @products = ::Products::HealthProduct.all
    @tenant = ::Tenants::Tenant.find(params[:tenant_id])
    @years = ::Enterprises::BenefitYear.all.pluck(:calendar_year)
  end

  def upload_plan_data
    # SERFF Template
    params.permit!
    result = Transactions::UploadSerffTemplate.new.call(params.to_h)

    if result.success?
      redirect_to admin_tenant_plan_index_path(params[:id])
    else
      result.failure
      # display errors on the same page
    end
  end

  def zip_county_data
    # County/Zipcode Mapping File
    params.permit!
    result = Transactions::CountyZipFile.new.call(params.to_h)

    if result.success?
      redirect_to admin_tenant_plan_index_path(params[:id])
    else
      result.failure
      # display errors on the same page
    end
  end

  def plans_destroy
    result = ::Transactions::PlansDestroy.new.call(params)

    if result.success?
      flash[:notice] = 'Successfully destroyed plans'
      redirect_to admin_tenant_plan_index_path(params[:id])
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
    params.require(:options_option).to_h
  end
end
