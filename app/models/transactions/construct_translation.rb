module Transactions
  class ConstructTranslation
    include Dry::Transaction

    step :build
    step :initialize_entity

    def build(input, tenant, action)
      @tenant = tenant
      translation_option = @tenant.translations

      if action == :fetch_locales
        locale = get_locale_for(input[:from_locale])
      elsif action == :edit_translation
        locale = get_locale_for(input[:to_locale])
      elsif action == :update_translation
        locale = get_locale_for(input[:translation][:current_locale]) 
      end

      if input[:to_locale].present? && locale.blank?
        language = @tenant.languages.options.where(key: input[:to_locale].to_sym).first
        locale   = translation_option.child_options.create(key: language.key, title: language.title, type: language.type)
      end

      current_locale = locale || default_locale

      page = input[:page] || 'site'

      current_locale_options = current_locale.child_options.select{|option| option.key.to_s.match(/^#{page}/).present?}

      editable_translation = if action == :edit_translation
        fetch_or_build_translation_for(current_locale, input[:translation_key])
      elsif action == :update_translation
        fetch_or_build_translation_for(current_locale, input[:translation][:translation_key])
      end

      entity_hash = {
         translation_option: translation_option,
         current_locale: current_locale,
         sections: sections,
         current_locale_options: current_locale_options,
         editable_translation: editable_translation || current_locale_options.first
      }

      Success(entity_hash)
    end

    def initialize_entity(input)
      entity = Translation.new(input)

      Success(entity)
    end

    def fetch_or_build_translation_for(current_locale, translation_key)
      current_locale.child_options.by_key(translation_key.to_sym).first || current_locale.child_options.build(key: translation_key.to_sym)
    end

    def get_locale_for(locale_key)
      if locale_key.present?
        @tenant.translations.child_options.by_key(locale_key.to_sym).first
      end
    end

    def default_locale
      @tenant.translations.child_options.by_key(:en).first
    end

    def sections
      default_locale.child_options.pluck(:key).collect{|key| key.to_s.split('.')[0]}.uniq
    end
  end
end