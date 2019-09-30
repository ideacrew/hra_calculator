class Admin::EnterpriseController < ApplicationController
  layout 'admin'

  def show
    @enterprise = ::Enterprises::Enterprise.first
    # @accounts = Account.all.pluck(:email)    
    @accounts = Account.all
    @states = Locations::UsState::NAME_IDS.map(&:first)
    @tenants = @enterprise.tenants
    @benefit_years = [Date.today.year, Date.today.next_year.year]
  end

  def account_create
    # TODO: refactor to take enterprise id if needed.
    create_tenant = Transactions::CreateAccount.new
    result = create_tenant.call(account_create_params)

    if result.success?
      flash[:notice] = "Successfully created"
    else
      flash[:error]  = result.failure[:errors]
    end
    redirect_to admin_enterprise_url(current_account.enterprise)
  end

  def tenant_create
    create_tenant = Transactions::CreateTenant.new
    result = create_tenant.with_step_args(fetch: [enterprise_id: ::Enterprises::Enterprise.all.first.id]).call(tenant_params)
    if result.success?
      flash[:notice] = "Successfully created #{result.success.owner_organization_name}"
    else
      flash[:error]  = 'Something went wrong.'
    end
    redirect_to action: :show, id: params[:enterprise_id]
  end

  def benefit_year_create
    create_benefit_year = Transactions::CreateBenefitYear.new
    result = create_benefit_year.with_step_args(fetch: [enterprise_id: by_create_params[:id]]).call(by_create_params)

    if result.success?
      redirect_to :show
    else
      result.failure
      # display errors on the same page
    end
  end

  def benefit_year_update
    update_benefit_year = Transactions::UpdateBenefitYear.new
    result = update_benefit_year.call(by_update_params)
    if result.success?
      flash[:notice] = "Successfully updated"
    else
      flash[:error]  = result.failure[:errors]
    end
    redirect_to admin_enterprise_path(params["enterprise_id"])
  end

  private

  # TODO: refactor all the below methods accordingly.
  def by_update_params
    # by_update_params = {expected_contribution: 0.0922, calendar_year: 2021, benefit_year_id: ::Enterprises::BenefitYear.first.id}
    params.permit!
    params.to_h
  end

  def by_create_params
    # by_create_params = {expected_contribution: 0.0974, calendar_year: 2022, id: ::Enterprises::Enterprise.first.id}
    params.permit!
    params.to_h
  end

  def account_create_params
    # account_create_params = {:email=>"asjdb@jhbs.com", password: "Abcd!1234"}
    params.permit!
    params.to_h
  end

  # filter tenant params
  def tenant_params
    # tenant_params = {key: :ma, owner_organization_name: 'MA Marketplace', account_email: "asjdb@jhbs.com"}
    key = Locations::UsState::NAME_IDS.select { |v| v[0] == params[:admin][:state] }[0][1]
    {
      key: key.downcase,
      owner_organization_name: params[:tenant][:value],
      account_email: params[:admin][:account]
    }
  end
end