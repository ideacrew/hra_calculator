class Sites::Site
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key,         type: Symbol
  field :title,       type: String
  field :description, type: String

  field :marketplace_name, type: String
  field :marketplace_website_url, type: String
  field :call_center_phone, type: String

  belongs_to  :tenant,
              class_name: 'Tenants::Tenant'

  has_many    :environments

  has_many    :features,
              class_name: 'Features::Feature'

  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'

  accepts_nested_attributes_for :features, :options

end
