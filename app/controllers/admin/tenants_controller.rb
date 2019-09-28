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
    # SERFF Template
    params.permit!
    result = Transactions::UploadSerffTemplate.new.call(params.to_h)

    if result.success?
      redirect_to :show
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
      redirect_to :show
    else
      result.failure
      # display errors on the same page
    end
  end
end
