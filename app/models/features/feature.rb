class Features::Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  recursively_embeds_many

  belongs_to :site, 
              class_name: 'Sites::Site'

  field :key,         type: Symbol
  field :is_required, type: Boolean
  field :is_enabled,  type: Boolean
  field :alt_key,     type: Symbol
  field :title,       type: String
  field :description, type: String

  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'
  
  def features=(feature_params)
    feature_params.each do |feature_hash|
      self.child_features.build(feature_hash)
    end
  end

  def features
    child_features
  end

  def to_h
  end
end
