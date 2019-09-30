class ApplicationController < ActionController::Base
  
  # include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? || request.format.js? }

  before_action :require_login, unless: :authentication_not_required?
  before_action :authenticate_me

  def require_login
    redirect_to new_account_session_path unless current_account
  rescue Exception => e
    Rails.logger.info { e.message }
  end

  protected

  def authentication_not_required?
    devise_controller? ||
      (controller_name == "configurations") ||
      (controller_name == "hra_results")
  end

  def authenticate_me
    return true if ['configurations' || 'hra_results'].include?(controller_name.downcase)
    authenticate_account!
  end

  def after_sign_in_path_for(resource)
    admin_enterprise_path(id: resource.id)
    if resource.enterprise.present?
      admin_enterprise_path(id: resource.enterprise.id)
    elsif resource.tenant.present?
      admin_tenant_path(id: resource.tenant.id)
    end
  end

end