# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Admin::EnterpriseController, type: :controller, dbclean: :after_each do
  include_context 'setup enterprise admin seed'

  describe "GET #show" do
    before do
      sign_in owner_account
      get :show, params: {id: enterprise.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'should set an instance variable' do
      expect(controller.instance_variable_get(:@states).count).to eq(52)
      expect(controller.instance_variable_get(:@accounts)).not_to be_nil
    end

    it 'should render template' do
      expect(response).to render_template('show')
    end
  end

  describe "POST #account_create" do
    context 'for success case' do
      before do
        allow_any_instance_of(Transactions::CreateAccount).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(''))
        sign_in owner_account
        post :account_create, params: {enterprise_id: enterprise.id}
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Account was created successfully.'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_url(enterprise))
      end
    end

    context 'for failure case' do
      before do
        allow_any_instance_of(Transactions::CreateAccount).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new({errors: ['Cannot create Account.']}))
        sign_in owner_account
        post :account_create, params: {enterprise_id: enterprise.id}
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Cannot create Account.'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_url(enterprise))
      end
    end
  end

  describe "POST #tenant_create" do
    let(:tenant_create_params) do
      { 'admin' => {'state' => 'Massachusetts', 'account' => 'admin@ma.com'},
        'tenant' => {'value' => 'ma mpl'},
        'enterprise_id' => enterprise.id}
    end

    let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
    let(:tenant_params) do
      { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
    end
    let(:value_for_age_rated) { 'age_rated' }
    let(:value_for_geo_rating_area) { 'zipcode' }
    include_context 'setup tenant'

    context 'for success case' do
      before do
        allow_any_instance_of(Transactions::CreateTenant).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(tenant))
        sign_in owner_account
        post :tenant_create, params: tenant_create_params
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq "Successfully created #{tenant.owner_organization_name}"
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path({id: enterprise.id}))
      end
    end

    context 'for failure case' do
      before do
        allow_any_instance_of(Transactions::CreateTenant).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new({errors: {marketplace: 'already exists for the selected state.'}}))
        sign_in owner_account
        post :tenant_create, params: tenant_create_params
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Marketplace already exists for the selected state.'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path({id: enterprise.id}))
      end
    end
  end

  describe "POST #benefit_year_update" do
    let(:benefit_year_create_params) do
      { "admin" => {"benefit_year" => benefit_year.calendar_year},
        "enterprises_enterprise" => {"value"=>"0.0978"},
        "enterprise_id" => enterprise.id}
    end

    context 'for success case' do
      before do
        allow_any_instance_of(Transactions::UpdateBenefitYear).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(''))
        sign_in owner_account
        post :benefit_year_update, params: benefit_year_create_params
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully updated'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path({id: enterprise.id}))
      end
    end

    context 'for failure case' do
      before do
        allow_any_instance_of(Transactions::UpdateBenefitYear).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new({errors: ['Failed to save benefit year']}))
        sign_in owner_account
        post :benefit_year_update, params: benefit_year_create_params
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Failed to save benefit year'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path({id: enterprise.id}))
      end
    end
  end

  describe "GET #purge_hra" do
    context 'for success case' do
      before do
        allow_any_instance_of(Transactions::PurgeHra).to receive(:call).and_return(Dry::Monads::Result::Success.new(''))
        sign_in owner_account
        get :purge_hra, params: {enterprise_id: enterprise.id}
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully purged HRA database.'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path({id: enterprise.id}))
      end
    end

    context 'for failure case' do
      before do
        allow_any_instance_of(Transactions::PurgeHra).to receive(:call).and_return(Dry::Monads::Result::Failure.new({errors: ['There are no tenants.']}))
        sign_in owner_account
        get :purge_hra, params: {enterprise_id: enterprise.id}
      end

      it "returns http success" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'There are no tenants.'
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path({id: enterprise.id}))
      end
    end
  end
end
