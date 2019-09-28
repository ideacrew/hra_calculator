class Options::Option
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, type: Symbol
  field :namespace, type: Boolean, default: true

  field :title, type: String
  field :description, type: String
  field :type, type: Symbol
  field :default, type: String
  field :value, type: String
  field :choices, type: Array

  field :aria_label, type: String

  recursively_embeds_many

  accepts_nested_attributes_for :child_options

  embedded_in :configurable, polymorphic: true

  def options
    child_options
  end

  def namespaces
    child_options.select(&:namespace)
  end

  def settings
    child_options.collect(&:setting_hash)
  end

  def setting_hash
    {
      key: key,
      title: title,
      description: description,
      type: type,
      default: default,
      value: value,
      aria_label: aria_label,
    }
  end

  def settings=(params)
    params.each {|param_hash| child_options.build(param_hash.merge(namespace: false)) }
  end

  def namespaces=(params)
    params.each {|param_hash| child_options.build(param_hash) }
  end
end