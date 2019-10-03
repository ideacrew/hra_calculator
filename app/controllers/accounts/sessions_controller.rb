class Accounts::SessionsController < Devise::SessionsController

    #after_action :log_failed_login, :only => :new

  def create
    self.resource = warden.authenticate!(auth_options)
    flash.now.notice = :signed_in if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?

    if location = after_sign_in_path_for(resource)
      respond_with resource, location: location
    else
      redirect_to action: :destroy, error: :resource_not_found
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    if signed_out
      if params[:error]
        set_flash_message! :error, params[:error]
      else
        set_flash_message! :notice, :signed_out
      end
    end
     
    yield if block_given?
    respond_to_on_destroy
  end

  private

  # def log_failed_login
  #   return unless failed_login?
  #   attempted_user = User.where(email: request.filtered_parameters["user"]["login"])
  #   if attempted_user.present?
  #     SessionIdHistory.create(session_user_id: attempted_user.first.id, sign_in_outcome: "Failed", ip_address: request.remote_ip)
  #   end
  # end

  # def failed_login?
  #   (options = Rails.env["warden.options"]) && options[:action] == "unauthenticated"
  # end
end
