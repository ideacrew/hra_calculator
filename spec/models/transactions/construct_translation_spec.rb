# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

describe ::Transactions::ConstructTranslation, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let!(:invalid_account) { FactoryBot.create(:account, enterprise_id: enterprise.id) }
  let(:tenant_params) do
    { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
  end
  let(:value_for_age_rated) { 'age_rated' }
  let(:value_for_geo_rating_area) { 'zipcode' }
  include_context 'setup tenant'

  describe 'case for fetch_locales' do
    let(:params) do
      { page: 'site', from_locale: 'en', to_locale: 'es', tenant_id: tenant.id.to_s}
    end

    before do
      @result = subject.with_step_args(build: [tenant, :fetch_locales]).call(params).value!
    end

    it 'should return an object of type Translation' do
      expect(@result).to be_a Translation
    end

    it 'should init Translation with all required data' do
      Translation.schema.keys.map(&:name).map(&:to_s).each do |keyy|
        expect(@result.send(keyy)).not_to be_nil
      end
    end
  end

  describe 'case for edit_translation' do
    let(:params) do
      { page: 'about_hra', from_locale: 'en', to_locale: 'en', translation_key: 'about_hra.header.title', tenant_id: tenant.id.to_s }
    end

    before do
      @result = subject.with_step_args(build: [tenant, :fetch_locales]).call(params).value!
    end

    it 'should return an object of type Translation' do
      expect(@result).to be_a Translation
    end

    it 'should init Translation with all required data' do
      Translation.schema.keys.map(&:name).map(&:to_s).each do |keyy|
        expect(@result.send(keyy)).not_to be_nil
      end
    end
  end

  describe 'case for update_translation' do
    let(:value) { "<div>About the HRA You've Been ____Offered</div>" }

    let(:params) do
      { translation: { current_locale: 'en', translation_key: 'about_hra.header.title', value: value },
        translation_key: 'about_hra.header.title',
        tenant_id: tenant.id.to_s }
    end

    before do
      @result = subject.with_step_args(build: [tenant, :update_translation]).call(params).value!
    end

    it 'should return an object of type Translation' do
      expect(@result).to be_a Translation
    end

    it 'should init Translation with all required data' do
      Translation.schema.keys.map(&:name).map(&:to_s).each do |keyy|
        expect(@result.send(keyy)).not_to be_nil
      end
    end
  end
end
