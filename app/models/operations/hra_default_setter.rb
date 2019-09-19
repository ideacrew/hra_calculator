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
        start_month_dates: (Date.new(year).beginning_of_year..Date.new(year).end_of_year).map(&:to_s),
        end_month_dates: (Date.new(year).beginning_of_year..Date.new(year).end_of_year.prev_month).map(&:to_s)
      })

      Success(hra_defaulter)
    end
  end
end
