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
      color_options   = ::Operations::ColorOptions.new.call(tenant)
      feature_options = ::Operations::TenantFeatures.new.call(tenant)

      consumer_portal = tenant.sites.detect{|site| site.key == :consumer_portal}
      ui_elements     = consumer_portal.options.by_key(:ui_elements).first
      translation_ele = consumer_portal.options.by_key(:translations).first

      state = Locations::UsState::NAME_IDS.detect{|state| state[1] == tenant.key.to_s.upcase}

      hra_defaulter = ::HraDefaulter.new({
        state_name: state[0],
        counties: counties,
        display_county: validate_county, # not using this - refer to features
        display_zipcode: offerings_constrained_to_zip_codes, # not using this - refer to features
        tax_credit: tax_credit,
        market_place: market_place,
        colors: color_options.value!,
        features: feature_options.value!,
        pages: ui_elements.child_options.map(&:to_h),
        translations: extract_translations(tenant, translation_ele)
      })

      Success(hra_defaulter)
    end

    # send translations only for the languages offered by marketplace
    def extract_translations(tenant, translation_element)
      results = Hash.new
      languages_supported = tenant.supported_language_options.map(&:key)
      translation_element.options.each do |option|
        next unless languages_supported.include?(option.key)
        locales = option.child_options.inject({}) do |locales, child_option|
          locales[child_option.key] = child_option.value || child_option.default
          locales
        end
        results[option.key] = process_locales(locales)
      end
      results
    end

    def process_locales(locales)
      result = {}
      
      locales.each do |key, value|
        result.deep_merge!(process_key(key.to_s, value))
      end

      result
    end

    def process_key(key, value, result = {})
      keys = key.split('.')
      if keys.count == 1
        result[key] = value
      elsif keys.count == 2
        result[keys[0]] ||= {}
        result[keys[0]][keys[1]] = value 
      else
        result[keys[0]] ||= {}
        result[keys[0]] = process_key(keys[1..-1].join('.'), value, result[keys[0]])
      end
      result
    end
  end
end
