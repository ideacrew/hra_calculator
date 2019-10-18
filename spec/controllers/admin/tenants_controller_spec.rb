# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Admin::TenantsController, type: :controller, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let(:tenant_params) do
    { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
  end
  let(:value_for_age_rated) { 'age_rated' }
  let(:value_for_geo_rating_area) { 'zipcode' }
  include_context 'setup tenant'

  let(:controller_params) do
    {'tenants_tenant' => {'owner_organization_name'=>'DC mpl', 'sites_attributes'=>{'0'=>
      {'options_attributes'=>
        {'1'=>
          {'child_options_attributes'=>
            {'0'=>{'value'=>'My Health Connector', 'id'=>'id'},
             '1'=>{'value'=>'https://openhbx.org', 'id'=>'id'},
             '2'=>{'value'=>'1-800-555-1212', 'id'=>'id'}},
             'id'=>'id'},
         '2'=>
          {'child_options_attributes'=>
            {'0'=>{'value'=>'https://test', 'id'=>'id'},
             '1'=>
              {'child_options_attributes'=>
                {'0'=>{'value'=>'#007bff', 'id'=>'id'},
                 '1'=>{'value'=>'#868e96', 'id'=>'id'},
                 '2'=>{'value'=>'#28a745', 'id'=>'id'},
                 '3'=>{'value'=>'#dc3545', 'id'=>'id'},
                 '4'=>{'value'=>'#ffc107', 'id'=>'id'},
                 '5'=>{'value'=>'#cce5ff', 'id'=>'id'}},
                'id'=>'id'}},
              'id'=>'id'},
          '3'=>{'child_options_attributes'=>{'0'=>{'id'=>'id'}}, 'id'=>'id'}},
          'id'=>'id'}}},'id'=>tenant.id}
  end

  describe "POST #update" do
    context 'for success case' do
      before :each do
        allow_any_instance_of(Transactions::UpdateTenant).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(tenant))
        sign_in tenant_account
        post :update, params: controller_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_path(id: tenant.id, tab_name: tenant.id.to_s+"_profile"))
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully updated marketplace settings'
      end
    end

    context 'for failure case' do
      before :each do
        allow_any_instance_of(Transactions::UpdateTenant).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new(tenant))
        sign_in tenant_account
        post :update, params: controller_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_path(id: tenant.id, tab_name: tenant.id.to_s+"_profile"))
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Something went wrong.'
      end
    end
  end

  describe "PUT #features_update" do
    context 'for success case' do
      before :each do
        allow_any_instance_of(Transactions::UpdateTenant).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(tenant))
        sign_in tenant_account
        put :features_update, params: controller_params.merge!(tenant_id: tenant.id)
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_features_show_path(id: tenant.id, tab_name: tenant.id.to_s+"_features"))
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully updated marketplace settings'
      end
    end

    context 'for failure case' do
      before :each do
        allow_any_instance_of(Transactions::UpdateTenant).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new(tenant))
        sign_in tenant_account
        put :features_update, params: controller_params.merge!(tenant_id: tenant.id)
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_features_show_path(id: tenant.id, tab_name: tenant.id.to_s+"_features"))
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Something went wrong.'
      end
    end
  end

  describe "GET #ui_pages_show" do
    before :each do
      sign_in tenant_account
      get :ui_pages_show, params: {tenant_id: tenant.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'should set an instance variable' do
      option = controller.instance_variable_get(:@page)
      expect(option).to be_a ::Options::Option
      expect(option.key).to eq(:ui_tool_pages)
    end

    it 'should render template' do
      expect(response).to render_template('ui_pages_show')
    end
  end

  describe "PATCH #ui_element_update" do
    let(:ui_element_params) do
      { 'option'=>{'default'=>"<div>a tax creditttt</div>"},
        'option_id'=>'5da62e567120eb0001bc3723',
        'tenant_id'=>tenant.id }
    end

    context 'for success case' do
      before :each do
        allow_any_instance_of(Transactions::UpdateUiElement).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(tenant))
        sign_in tenant_account
        patch :ui_element_update, params: ui_element_params.merge!({tenant_id: tenant.id})
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_ui_pages_show_path(id: tenant.id, tab_name: tenant.id.to_s+"_ui_pages"))
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully updated page settings'
      end
    end

    context 'for failure case' do
      before :each do
        allow_any_instance_of(Transactions::UpdateUiElement).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new(tenant))
        sign_in tenant_account
        patch :ui_element_update, params: ui_element_params.merge!({tenant_id: tenant.id})
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_ui_pages_show_path(id: tenant.id, tab_name: tenant.id.to_s+"_ui_pages"))
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Something went wrong.'
      end
    end
  end

  describe "GET #ui_pages_edit" do
    let(:option) { tenant.sites[0].options.where(key: :ui_tool_pages).first.options.first }
    let(:ui_pages_edit_params) do
      { 'option' => { 'default' => "<div>a tax creditttt</div>"},
        'option_id' => option.id,
        'tenant_id' => tenant.id }
    end

    before :each do
      sign_in tenant_account
      get :ui_pages_edit, params: ui_pages_edit_params, xhr: true
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'should set some instance variables' do
      expect(controller.instance_variable_get(:@tenant)).to eq(tenant)
      expect(controller.instance_variable_get(:@option)).to eq(option)
    end

    it 'should render template' do
      expect(response).to render_template('ui_pages_edit')
    end
  end

  describe "GET #plan_index" do
    before :each do
      sign_in tenant_account
      get :plan_index, params: {tenant_id: tenant.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'should set some instance variables' do
      expect(controller.instance_variable_get(:@years)).to eq([2020])
      expect(controller.instance_variable_get(:@tenant)).to eq(tenant)
      expect(controller.instance_variable_get(:@products)).to eq(tenant.products.all)
    end

    it 'should render template' do
      expect(response).to render_template('plan_index')
    end
  end

  describe "POST #upload_plan_data" do
    context 'for success case' do
      before :each do
        allow_any_instance_of(Transactions::SerffTemplateUpload).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(tenant))
        sign_in tenant_account
        get :upload_plan_data, params: { tenant_id: tenant.id }
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_plan_index_path(tenant.id, tab_name: tenant.id.to_s+"_plans"))
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully uploaded plans'
      end
    end

    context 'for failure case' do
      before :each do
        allow_any_instance_of(Transactions::SerffTemplateUpload).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new({errors: ['Failure case']}))
        sign_in tenant_account
        get :upload_plan_data, params: { tenant_id: tenant.id }
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_plan_index_path(tenant.id, tab_name: tenant.id.to_s+"_plans"))
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Failure case'
      end
    end
  end

  describe "GET #plans_destroy" do
    context 'for success case' do
      before :each do
        allow_any_instance_of(Transactions::PlansDestroy).to receive(:call).with(anything).and_return(Dry::Monads::Result::Success.new(tenant))
        sign_in tenant_account
        get :plans_destroy, params: { id: tenant.id, tenant_id: tenant.id }
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_plan_index_path(tenant.id, tab_name: tenant.id.to_s+"_plans"))
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq 'Successfully destroyed plans'
      end
    end

    context 'for failure case' do
      before :each do
        allow_any_instance_of(Transactions::PlansDestroy).to receive(:call).with(anything).and_return(Dry::Monads::Result::Failure.new({errors: ["Unable to find tenant record with id #{tenant.id}"]}))
        sign_in tenant_account
        get :plans_destroy, params: { id: tenant.id, tenant_id: tenant.id }
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_tenant_plan_index_path(tenant.id, tab_name: tenant.id.to_s+"_plans"))
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq "Unable to find tenant record with id #{tenant.id}"
      end
    end
  end
end
