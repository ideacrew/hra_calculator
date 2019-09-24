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
        start_month_dates: fetch_start_dates(year),
        end_month_dates: fetch_end_dates(year),
        tax_credit: tax_credit,
        market_place: market_place
      })

      Success(hra_defaulter)
    end

    def fetch_start_dates(year)
      (1..12).inject([]) do |dates, mon|
        dates << "#{year}-#{mon}-1"
      end
    end

    def fetch_end_dates(year)
      result_arr = (year..(year+1)).inject([]) do |dates, c_year|
                     (1..12).each do |mon|
                       dates << "#{c_year}-#{mon}-1"
                     end
                     dates
                   end
      result_arr - ["#{year + 1}-12-1"]
    end
  end
end
