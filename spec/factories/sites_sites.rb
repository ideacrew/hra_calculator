FactoryBot.define do
  factory :site, class: 'Sites::Site' do
    tenant { FactoryBot.create(:tenant, enterprise: FactoryBot.create(:enterprise)) }
  end
end
