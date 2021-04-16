module Operations
  class ImportCountyZip
    include Dry::Transaction::Operation

    def call(county_zip_params)
      file = county_zip_params[:file]
      year = county_zip_params[:year]
      tenant = county_zip_params[:tenant]
      import_timestamp = county_zip_params[:import_timestamp]
      state_abbreviation = tenant.key.to_s.upcase

      begin
        result = Roo::Spreadsheet.open(file)
        sheet_data = result.sheet(0)
        @header_row = sheet_data.row(1)
        assign_headers
        last_row = sheet_data.last_row
        (2..last_row).each do |row_number| # data starts from row 2, row 1 has headers
          row_info = sheet_data.row(row_number)
          county_name = row_info[@headers["county"]].squish!
          county_name.strip!
          zip_code = (tenant.geographic_rating_area_model == 'county') ? nil : row_info[@headers["zip"]].squish!
          query_criteria = {state: state_abbreviation, county_name: county_name}
          query_criteria.merge!({zip: zip_code}) unless tenant.geographic_rating_area_model == 'county'
          existing_county = ::Locations::CountyZip.where(query_criteria)
          next if existing_county.present?

          params = query_criteria.merge!({created_at: import_timestamp})
          ::Locations::CountyZip.new(params).save!
        end

        return Success('Created CountyZips for given data')
      rescue
        return Failure({errors: ["Unable to create data from file #{File.basename(file)}"]})
      end
    end

    def assign_headers
      @headers = Hash.new
      @header_row.each_with_index {|header,i|
        @headers[header.to_s.underscore] = i
      }
      @headers
    end
  end
end
