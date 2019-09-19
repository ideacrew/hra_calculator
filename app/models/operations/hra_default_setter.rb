module Operations
  class HraDefaultSetter
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call
      counties = ::Locations::CountyZip.all.pluck(:county_name).uniq
      year = ::Date.today.year
      hra_defaulter = ::HraDefaulter.new({
        state_name: state_full_name,
        counties: counties,
        display_county: validate_county,
        display_zipcode: validate_zipcode,
        start_month_dates: (Date.new(year, 1, 1)..Date.new(year, 12, 31)).map(&:to_s),
        end_month_dates: (Date.new(year, 1, 1)..Date.new(year + 1, 11, 30)).map(&:to_s)
      })

      Success(hra_defaulter)
    end
  end
end
