module Operations
  class HraDefaultResultsSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call(key)
      tenant = Tenants::Tenant.find_by_key(key)

      site = tenant.sites.first
      ui_tool_page_option = site.options.by_key(:ui_tool_pages).first
      page_options = ui_tool_page_option.options.pluck(:key, :value, :default)

      color_options = ::Operations::ColorOptions.new.call(tenant)

      hra_results = ::HraResults.new(option_array_to_hash(page_options).merge(colors: color_options.value!))

      Success(hra_results)
    end

    def option_array_to_hash(options)
      options.inject({}) do |data, element_array|
        data[element_array[0]] = element_array[1] || element_array[2]
        data
      end
    end
  end
end
