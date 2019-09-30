module Operations
  class UiPageOptions
    include Dry::Transaction::Operation

    def call(tenant)
      site   = tenant.sites.first      

      ui_tool_page_option = site.options.by_key(:ui_tool_pages).first
      page_options = ui_tool_page_option.options.pluck(:key, :value, :default)

      Success(option_array_to_hash(page_options))
    end

    def option_array_to_hash(options)
      options.inject({}) do |data, element_array|
        data[element_array[0]] = element_array[1] || element_array[2]
        data
      end
    end
  end
end
