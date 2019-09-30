module Operations
  class TenantFeatures
    include Dry::Transaction::Operation

    def call(tenant)
      site    = tenant.sites.first
      feature = site.features.first

      feature_settings = feature.options.collect{|o| settings_under(o) }.flatten
      feature_setting_values = feature_settings.map{|f| [f.key, f.value, f.default]}

      Success(option_array_to_hash(feature_setting_values))
    end

    def settings_under(option)
      if option.namespace
        option.options.each{|o| settings_under(o)}
      else
        option
      end
    end

    def option_array_to_hash(options)
      options.inject({}) do |data, element_array|
        data[element_array[0]] = element_array[1] || element_array[2]
        data
      end
    end
  end
end
