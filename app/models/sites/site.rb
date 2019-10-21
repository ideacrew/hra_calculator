class Sites::Site
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key,         type: Symbol
  field :title,       type: String
  field :description, type: String

  belongs_to  :tenant,
              class_name: 'Tenants::Tenant'

  # has_many    :environments

  has_many    :features,
              class_name: 'Features::Feature'

  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'
  
  scope :by_key, ->(key) { where(key: key) }

  accepts_nested_attributes_for :features, :options


  def environments
    [
      {
        key: :production,
        features: features.map(&:to_h)
      }
    ]
  end

  # Following method needs to be updated if multi environment params passed.
  def environments=(env_params)
    env_params.each do |env_hash|
      next unless env_hash[:features]
      env_hash[:features].each do |feature_hash|
        self.features.build(feature_hash)
      end
    end
  end

  def to_h
  end
end
