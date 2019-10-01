module Operations
  class HraDefaultResultsSetter
    include Dry::Transaction::Operation

    def call(key)
      tenant = Tenants::Tenant.find_by_key(key)

      site = tenant.sites.first

      ui_page_options = ::Operations::UiPageOptions.new.call(tenant)
      color_options   = ::Operations::ColorOptions.new.call(tenant)

      hra_results = ::HraResults.new(ui_page_options.value!.merge(colors: color_options.value!))

      Success(hra_results)
    end
  end
end
