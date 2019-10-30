class Translation < Dry::Struct
  transform_keys(&:to_sym)

  attribute :translation_option, Types::Any
  attribute :sections, Types::Array
  attribute :current_locale, Types::Any
  attribute :current_locale_options, Types::Array
  attribute :editable_translation, Types::Any
  attribute :from_locale, Types::Symbol
  attribute :to_locale, Types::Symbol
  attribute :page, Types::String
end
