module Operations
  class ImportRatingArea
    include Dry::Transaction::Operation

    def call(params)
      file = params[:file]
      year = params[:year]
      tenant = params[:tenant]
      state_abbreviation = tenant.key.to_s.upcase
      offerings_constrained_to_rating_area = tenant.has_rating_area_constraints?

      begin
        if offerings_constrained_to_rating_area
          xlsx = Roo::Spreadsheet.open(file)
          sheet = xlsx.sheet(0)

          @result_hash = Hash.new {|results, k| results[k] = []}

          (2..sheet.last_row).each do |i|
            @result_hash[sheet.cell(i, 4)] << {
                "county_name" => sheet.cell(i, 2),
                "zip" => sheet.cell(i, 1)
            }
          end

          @result_hash.each do |rating_area_id, locations|

            location_ids = locations.map do |loc_record|
              county_zip = ::Locations::CountyZip.where(
                {
                  zip: loc_record['zip'],
                  county_name: loc_record['county_name']
                }
              ).first
              county_zip._id
            end

            ra = ::Locations::RatingArea.where(
              {
                active_year: year,
                exchange_provided_code: rating_area_id
              }
            ).first
            if ra.present?
              ra.county_zip_ids = location_ids
              ra.save
            else
              ::Locations::RatingArea.find_or_create_by!(
                {
                  active_year: year,
                  exchange_provided_code: rating_area_id,
                  county_zip_ids: location_ids
                }
              )
            end
          end
        else
          ::Locations::RatingArea.find_or_create_by!(
            {active_year: year,
             exchange_provided_code: '',
             county_zip_ids: [],
             covered_states: [state_abbreviation]}
           )
        end

        Success('Created Plan for given data')
      rescue
        Failure('Unable to create Plan for given data')
      end
    end

    def to_boolean(value)
      return true if value == true || value =~ (/(true|t|yes|y|1)$/i)
      return false if value == false || value =~ (/(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{value}\"")
    end
  end
end
