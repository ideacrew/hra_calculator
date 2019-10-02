FactoryBot.define do
  factory :enterprise, class: '::Enterprises::Enterprise' do
    
    owner_organization_name { "My Organization" }
  end
end
