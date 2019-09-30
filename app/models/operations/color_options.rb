module Operations
  class ColorOptions
    include Dry::Transaction::Operation

    def call(tenant)
      site   = tenant.sites.first      

      ui_theme_option  = site.options.by_key(:ui_theme).first
      bootstrap_pallette_option  = ui_theme_option.options.by_key(:bootstrap_pallette).first
      color_options = bootstrap_pallette_option.options.pluck(:key, :value, :default)

      Success(option_array_to_hash(color_options))
    end

    def option_array_to_hash(options)
      options.inject({}) do |data, element_array|
        data[element_array[0]] = element_array[1] || element_array[2]
        data
      end
    end
  end
end
