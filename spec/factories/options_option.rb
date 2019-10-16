FactoryBot.define do
  factory :option, class: '::Options::Option' do
    key         {'owner_organization_name'}
    default     {'My Organization'}
    description {'Name of the organization that manages'}
    type        {'string'}
  end
end
