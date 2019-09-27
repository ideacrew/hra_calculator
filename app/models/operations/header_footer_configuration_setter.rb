module Operations
  class HeaderFooterConfigurationSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call
      hf_config = ::HeaderFooterConfiguration.new({
        tenant_logo_file: tenant_logo_file,
        tenant_url: tenant_url,
        customer_support_number: customer_support_number,
        benefit_year: 2020 # TODO: Fix the benefit year.
      })

      Success(hf_config)
    end
  end
end
