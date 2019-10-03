class Admin::AccountsController < ApplicationController
  layout 'admin'
  skip_before_action :verify_authenticity_token

  def reset_password
    @enterprise = ::Enterprises::Enterprise.first
    @account = Account.find(params[:id])
  end

  def password_reset
    @enterprise = ::Enterprises::Enterprise.first
    @account = Account.find(params[:id])
    if @account.update_with_password(account_params)
      flash.now.notice = "Changed password for #{@account.email}."

      render 'password_reset'
    else
      flash[:errors] = @account.errors.full_messages
      render 'reset_password'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.tenant.destroy!
    @account.destroy!

    redirect_to admin_enterprise_path(Enterprises::Enterprise.first)
  end

	private
  def account_params
    params.require(:account).permit(:current_password, :password, :password_confirmation)
  end
end
