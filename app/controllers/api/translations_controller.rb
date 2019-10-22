module Api
  class TranslationsController < ApplicationController
    before_action :find_tenant

    def show
      language = params[:id] || "en"
      hra_default_setter = ::Operations::HraDefaultSetter.new.call(@tenant.key)
      @data =  hra_default_setter.success.to_h[:translations][language.to_sym]
      render json: @data
    end

    def find_tenant
      tenant_id = params[:tenant_id]
      @tenant = tenant_id.blank? ? Tenants::Tenant.first : Tenants::Tenant.find(tenant_id)
      @enterprise = @tenant.enterprise
    end
  end
end