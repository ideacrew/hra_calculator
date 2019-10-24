module Api
  class TranslationsController < ActionController::Base
    before_action :find_tenant

    def show
      language = params[:id] || "en"
      hra_default_setter = ::Operations::HraDefaultSetter.new.call(@tenant.key)
      @data =  hra_default_setter.success.to_h[:translations][language.to_sym]
      render json: @data
    end

    def find_tenant
      tenant_key = params.require(:tenant)
      @tenant = tenant_key.blank? ? Tenants::Tenant.first : Tenants::Tenant.find_by_key(tenant_key.to_sym)
      @enterprise = @tenant.enterprise
    end
  end
end