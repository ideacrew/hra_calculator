# frozen_string_literal: true

FactoryBot.define do
  factory :tenant, class: '::Tenants::Tenant' do
    key { Locations::UsState::NAME_IDS.sample[1].to_sym }
    sequence(:owner_organization_name) { |n| "Marketplace #{n}" }
  end
end
