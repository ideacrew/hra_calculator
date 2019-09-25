class Features::Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  recursively_embeds_many

  embedded_in :site, 
              class_name: 'Sites::Site'

  field :key, type: Symbol



  embeds_many :options, as: :configurable,
              class_name: 'Options::Option'

end
