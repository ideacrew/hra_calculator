module Operations
  class ImportRatingArea
    include Dry::Transaction::Operation

    def call(params)
      file = params[:file]
      year = params[:year]
      tenant = params[:tenant]
      import_timestamp = params[:import_timestamp]
      state_abbreviation = tenant.key.to_s.upcase

      begin
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
                county_name: loc_record['county_name'],
                state: state_abbreviation
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
            rating_area = ::Locations::RatingArea.where({
              active_year: year,
              exchange_provided_code: rating_area_id,
              county_zip_ids: location_ids
            })
            next if rating_area.present?

            ::Locations::RatingArea.new(
              {
                created_at: import_timestamp,
                active_year: year,
                exchange_provided_code: rating_area_id,
                county_zip_ids: location_ids
              }
            ).save!
          end
        end

        return Success('Created Plan for given data')
      rescue
        return Failure({errors: ["Unable to read data from file #{File.basename(file)}"]})
      end
    end

    def to_boolean(value)
      return true if value == true || value =~ (/(true|t|yes|y|1)$/i)
      return false if value == false || value =~ (/(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{value}\"")
    end
  end
end
