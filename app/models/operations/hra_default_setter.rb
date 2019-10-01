module Operations
  class HraDefaultSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call(key)
      counties = ::Locations::CountyZip.all.pluck(:county_name).uniq
      # TODO: Change this in year 2020 to ::Date.today.year
      year = ::Date.today.year + 1

      tenant = Tenants::Tenant.find_by_key(key)
      site   = tenant.sites.first
      ui_page_options = ::Operations::UiPageOptions.new.call(tenant)
      color_options   = ::Operations::ColorOptions.new.call(tenant)
      feature_options = ::Operations::TenantFeatures.new.call(tenant)

      state = Locations::UsState::NAME_IDS.detect{|state| state[1] == tenant.key.to_s.upcase}

      hra_defaulter = ::HraDefaulter.new({
        state_name: state[0],
        counties: counties,
        display_county: validate_county, # not using this - refer to features
        display_zipcode: offerings_constrained_to_zip_codes, # not using this - refer to features
        tax_credit: tax_credit,
        market_place: market_place,
        colors: color_options.value!,
        ui_pages: ui_page_options.value!,
        features: feature_options.value!
      })

      Success(hra_defaulter)
    end
  end
end
