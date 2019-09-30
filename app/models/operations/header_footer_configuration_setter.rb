module Operations
  class HeaderFooterConfigurationSetter
    include Dry::Transaction::Operation

    def call(key)
      tenant = Tenants::Tenant.find_by_key(key)
      site   = tenant.sites.first

      options = [:site, :branding].inject([])  do |data, key|
        site_option  = site.options.by_key(key).first
        data += site_option.options.pluck(:key, :value, :default)
      end

      option_hash = options.inject({}) do |data, element_array|
        data[element_array[0]] = element_array[1] || element_array[2]
        data
      end

      color_options = ::Operations::ColorOptions.new.call(tenant)

      Success(option_hash.merge(colors: color_options.value!))
    end
  end
end
