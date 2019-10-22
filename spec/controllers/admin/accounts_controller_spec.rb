# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Admin::AccountsController, type: :controller, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let(:account) { FactoryBot.create(:account, password: 'ChangeMe!', password_confirmation: 'ChangeMe!') }

  describe "GET #reset_password" do
    before do
      sign_in owner_account
      get :reset_password, params: {id: account.id}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'should set an instance variable enterprise' do
      expect(controller.instance_variable_get(:@enterprise)).to eq(enterprise)
    end

    it 'should set an instance variable account' do
      expect(controller.instance_variable_get(:@account)).to eq(account)
    end

    it 'should render template' do
      expect(response).to render_template('reset_password')
    end
  end

  describe "PATCH #password_reset" do
    context 'for success case' do
      let(:reset_params) do
        { account: {current_password: 'ChangeMe!', password: 'YesChangeMe!', password_confirmation: 'YesChangeMe!'}, id: account.id }
      end

      before do
        sign_in owner_account
        patch :password_reset, params: reset_params, xhr: true
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'should render template' do
        expect(response).to render_template('password_reset')
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq "Changed password for #{account.email}."
      end
    end

    context 'for failure case' do
      let(:reset_params) do
        { account: {current_password: 'ChangeMe!', password: 'YesChangeMe!', password_confirmation: 'NoChangeMe!'}, id: account.id }
      end

      before do
        sign_in owner_account
        patch :password_reset, params: reset_params, xhr: true
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'should render template' do
        expect(response).to render_template('reset_password')
      end

      it 'should set a flash errors' do
        expect(flash[:errors]).to eq ["Password confirmation doesn't match Password"]
      end
    end
  end

  describe "GET #destroy" do
    context 'for success case' do
      before do
        sign_in owner_account
        get :destroy, params: {id: account.id}
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path(enterprise.id))
      end

      it 'should set a flash notice' do
        expect(flash[:notice]).to eq "Successfully deleted account associated with email - #{account.email}"
      end
    end

    context 'for failure case' do
      before do
        allow_any_instance_of(Account).to receive(:destroy!).and_return(false)
        sign_in owner_account
        get :destroy, params: {id: account.id}
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it 'should redirect to a specific path' do
        expect(response).to redirect_to(admin_enterprise_path(enterprise.id))
      end

      it 'should set a flash error' do
        expect(flash[:error]).to eq 'Something went wrong.'
      end
    end
  end
end
