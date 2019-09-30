module Operations
  class ImportCountyZip
    include Dry::Transaction::Operation

    def call(county_zip_params)
      file = county_zip_params[:file]
      year = county_zip_params[:year]
      tenant = county_zip_params[:tenant]
      state_abbreviation = tenant.key.to_s.upcase
      offerings_constrained_to_zip_codes = tenant.zipcode_constraints?
      return Success('CountyZips are not required') if !tenant.countyzip_constraints? && !offerings_constrained_to_zip_codes

      begin
        result = Roo::Spreadsheet.open(file)
        sheet_data = result.sheet("Master Zip Code List")
        @header_row = sheet_data.row(1)
        assign_headers
        last_row = sheet_data.last_row
        (2..last_row).each do |row_number| # data starts from row 2, row 1 has headers
          row_info = sheet_data.row(row_number)
          if offerings_constrained_to_zip_codes
            ::Locations::CountyZip.find_or_create_by!({
              county_name: row_info[@headers["county"]].squish!,
              zip: row_info[@headers["zip"]].squish!,
              state: state_abbreviation
            })
          else
            ::Locations::CountyZip.find_or_create_by!({
              county_name: row_info[@headers["county"]].squish!,
              zip: '',
              state: state_abbreviation
            })
          end
        end

        Success('Created CountyZips for given data')
      rescue
        Failure('Unable to create Plan for given data')
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
