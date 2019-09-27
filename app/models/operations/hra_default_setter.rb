module Operations
  class HraDefaultSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call
      counties = ::Locations::CountyZip.all.pluck(:county_name).uniq
      # TODO: Change this in year 2020 to ::Date.today.year
      year = ::Date.today.year + 1
      hra_defaulter = ::HraDefaulter.new({
        state_name: state_full_name,
        counties: counties,
        display_county: validate_county,
        display_zipcode: offerings_constrained_to_zip_codes,
        tax_credit: tax_credit,
        market_place: market_place
      })

      Success(hra_defaulter)
    end
  end
end
