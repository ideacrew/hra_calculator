# This operation is specific to the state exchanges which are county based.

module Operations
  class StoreCountyZip
    include Dry::Transaction::Operation

    def call(cz_params)
      cz_files = cz_params[:cz_files]
      tenant = cz_params[:tenant]
      year = cz_params[:year]
      import_timestamp = cz_params[:import_timestamp]
      state_abbreviation = tenant.key.to_s.upcase
      row_data_begin = 13

      begin
        cz_files.each do |cz_file|
          xlsx = ::Roo::Spreadsheet.open(cz_file)
          sheet = xlsx.sheet(xlsx.sheets.index('Service Areas'))
          issuer_hios_id = sheet.cell(6,2).to_i.to_s
          (row_data_begin..sheet.last_row).each do |i|
            county_field = sheet.cell(i,4)
            next if county_field.nil?

            existing_county = ::Locations::CountyZip.where({
              state: state_abbreviation,
              county_name: county_field.split(' - ').first.squish!
            })
            next if existing_county.present?

            ::Locations::CountyZip.find_or_create_by!({
              created_at: import_timestamp,
              county_name: county_field.split(' - ').first.squish!,
              state: state_abbreviation
            })
          end
        end

        Success("Created county zips")
      rescue
        Failure({errors: ["Unable to create CountyZips for given counties per SA serff_templates"]})
      end
    end
  end
end
