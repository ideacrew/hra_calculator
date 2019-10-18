module Operations
  class HraDefaultSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call(key)
      counties = ::Locations::CountyZip.all.where(state: key.to_s.upcase).pluck(:county_name).uniq
      counties.sort!
      # TODO: Change this in year 2020 to ::Date.today.year
      year = ::Date.today.year + 1

      tenant = Tenants::Tenant.find_by_key(key)
      site   = tenant.sites.first
      ui_page_options = ::Operations::UiPageOptions.new.call(tenant)
      color_options   = ::Operations::ColorOptions.new.call(tenant)
      feature_options = ::Operations::TenantFeatures.new.call(tenant)

      site        = tenant.sites.detect{|site| site.key == :consumer_portal}
      ui_elements = site.options.by_key(:ui_elements).first


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
        features: feature_options.value!,
        ui_elements: ui_elements.child_options.map(&:to_h)
      })

      Success(hra_defaulter)
    end
  end
end
