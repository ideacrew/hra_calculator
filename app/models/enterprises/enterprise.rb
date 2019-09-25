class Enterprises::Enterprise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :owner_organization_name, type: String

  has_one   :owner_account,
            class_name: 'Account'

  has_many  :tenants,
            class_name: 'Tenants::Tenant'

  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'

  accepts_nested_attributes_for :tenants, :options

end
