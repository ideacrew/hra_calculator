module Operations
  class ImportServiceArea
    include Dry::Transaction::Operation

    def call(sa_params)
      # TODO: read file to check the file data
      sa_file = sa_params[:sa_file]
      tenant = sa_params[:tenant]
      year = sa_params[:year]
      state_abbreviation = tenant.key.to_s.upcase

      row_data_begin = 13
      total = 0
      begin
        xlsx = ::Roo::Spreadsheet.open(sa_file)
        sheet = xlsx.sheet(xlsx.sheets.index('Service Areas'))
        issuer_hios_id = sheet.cell(6,2).to_i.to_s
        (row_data_begin..sheet.last_row).each do |i|
          serves_state = sheet.cell(i,3)
          next if serves_state.nil?

          serves_entire_state = to_boolean(serves_state)
          serves_partial_county = serves_entire_state ? nil : to_boolean(to_boolean(sheet.cell(i,5)))
          if serves_entire_state
            sa = ::Locations::ServiceArea.where(
              active_year: year,
              issuer_provided_code: sheet.cell(i,1),
              covered_states: [state_abbreviation],
              issuer_provided_title: sheet.cell(i,2)
            ).first
            if sa.present?
              sa.issuer_hios_id = issuer_hios_id
              sa.save
            else
              ::Locations::ServiceArea.find_or_create_by!(
                active_year: year,
                issuer_provided_code: sheet.cell(i,1),
                covered_states: [state_abbreviation],
                issuer_hios_id: issuer_hios_id,
                issuer_provided_title: sheet.cell(i,2)
              )
            end
          elsif serves_entire_state == false

            existing_state_wide_areas = ::Locations::ServiceArea.where(
              active_year: year,
              issuer_provided_code: sheet.cell(i,1),
              issuer_hios_id: issuer_hios_id,
              covered_states: [state_abbreviation]
            )

            if existing_state_wide_areas.blank?
              county_name, state_code, county_code = extract_county_name_state_and_county_codes(sheet.cell(i,4))
              records = ::Locations::CountyZip.where({state: state_abbreviation, county_name: county_name})

              if tenant.geographic_rating_area_model == 'zipcode'
                if sheet.cell(i,6).present?
                  extracted_zips = extracted_zip_codes(sheet.cell(i,6)).each {|t| t.squish!}
                  records = records.where(:zip.in => extracted_zips)
                end
              end

              service_area_found = ::Locations::ServiceArea.where(
                 active_year: year,
                 issuer_provided_code: sheet.cell(i,1),
                 issuer_hios_id: issuer_hios_id
                ).first

              if service_area_found.blank?
                ::Locations::ServiceArea.create({
                  active_year: year,
                  issuer_provided_code: sheet.cell(i,1),
                  issuer_hios_id: issuer_hios_id,
                  issuer_provided_title: sheet.cell(i,2),
                  county_zip_ids: records.pluck(:_id)
                })
              else
                service_area_found.issuer_provided_title = sheet.cell(i,2)
                service_area_found.county_zip_ids = records.pluck(:_id)
                service_area_found.save
              end
            end
          end
        end

        Success('Created Service Area')
      rescue => e
        puts "service area issue, error: #{e.message}"
        Failure({errors: ["Unable to process file: #{sa_file}"]})
      end
    end

    def to_boolean(value)
      return true   if value == true   || value =~ (/(true|t|yes|y|1)$/i)
      return false  if value == false  || value =~ (/(false|f|no|n|0)$/i)
      return nil
    end

    def extracted_zip_codes(column)
      column.present? && column.split(/\s*,\s*/)
    end

    def extract_county_name_state_and_county_codes(county_field)
      begin
        county_name, state_and_county_code = county_field.split(' - ')
        [county_name, state_and_county_code[0..1], state_and_county_code[2..state_and_county_code.length]]
      rescue => e
        puts county_field
        puts e.inspect
        return ['undefined',nil,nil]
      end
    end
  end
end