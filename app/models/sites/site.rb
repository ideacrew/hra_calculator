class Sites::Site
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key,         type: Symbol
  field :title,       type: String
  field :description, type: String

  belongs_to  :tenant,
              class_name: 'Tenants::Tenant'

  has_many    :environments

  has_many    :features,
              class_name: 'Features::Feature'

  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'

  accepts_nested_attributes_for :features, :options


  def environments
  end

  def environments=()
  end

  def to_h
  end
end
