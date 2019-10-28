# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/test_enterprise_admin_seed')

RSpec.describe Operations::HeaderFooterConfigurationSetter, type: :model, dbclean: :after_each do
  include_context 'setup enterprise admin seed'
  let!(:tenant_account) { FactoryBot.create(:account, email: 'admin@market_place.org', enterprise_id: enterprise.id) }
  let(:tenant_params) do
    { key: :ma, owner_organization_name: 'MA Marketplace', account_email: tenant_account.email }
  end
  let(:value_for_age_rated) { 'age_rated' }
  let(:value_for_geo_rating_area) { 'zipcode' }
  include_context 'setup tenant'

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'for call' do
    before do
      @result = subject.call(:ma).success
    end

    it 'should have return value for marketplace_name' do
      expect(@result[:marketplace_name]).to eq('My Health Connector')
    end

    it 'should have return value for marketplace_website_url' do
      expect(@result[:marketplace_website_url]).to eq('https://openhbx.org')
    end

    it 'should have return value for call_center_phone' do
      expect(@result[:call_center_phone]).to eq('1-800-555-1212')
    end

    it 'should have specific keys for colors' do
      expect(@result[:colors].keys).to eq([:primary_color, :secondary_color, :success_color, :danger_color, :warning_color, :info_color, :typeface_name, :typeface_url, :typefaces, :bootstrap_pallette])
    end
  end
end
