# frozen_string_literal: true

module Transactions
  class LoadLocale

    include Dry::Transaction(container: ::Registry)

    LANGUAGE_MAP = {
      'English' => 'en',
      'Spanish' => 'es'
    }

    step :load_source,         with: 'resource_registry.stores.load_file'
    step :parse,               with: 'resource_registry.serializers.parse_yaml'
    step :symbolize_keys,      with: 'resource_registry.serializers.symbolize_keys'
    step :parse_options
    step :validate,            with: 'resource_registry.options.validate'

    private

    def parse_options(input)
      options = serialize_options(input.to_h)
      
      Success(options.first)
    end

    def serialize_options(key_map, result = [])
      key_map.inject([]) do |data, (key, value)|
        data << if value.is_a?(Hash)
          {key: key, settings: serialize_options(value)}
        else
          LANGUAGE_MAP.key(key).present? ? {key: key, default: value, title: LANGUAGE_MAP.key(key)} : {key: key, default: value}
        end
      end
    end

    def validate(input)
      result = super

      if result.success?
        Success(result)
      else
        Failure(result.errors)
      end
    end
  end
end


