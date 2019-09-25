class Options::Option
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, type: Symbol
  field :namespace, type: Symbol

  field :title, type: String
  field :description, type: String
  field :type, type: Symbol
  field :default, type: String
  field :value, type: String

  field :aria_label, type: String

  recursively_embeds_many

  embedded_in :configurable, polymorphic: true

  def namespaces
    child_options.reduce([]) { |list, option| list << option.namespace }
  end

  def settings
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

end
