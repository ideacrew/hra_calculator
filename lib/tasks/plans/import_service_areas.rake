namespace :load_service_reference do

  task :run_all_service_areas => :environment do
    files = Dir.glob(File.join(Rails.root, "db/seedfiles/plan_xmls/ma/xls_templates/service_areas", "**", "*.xlsx"))
    puts "*"*80 unless Rails.env.test?
    files.sort.each do |file|
      puts "processing file #{file}" unless Rails.env.test?
      # new model
      Rake::Task['load_service_reference:update_service_areas_new_model'].invoke(file)
      Rake::Task['load_service_reference:update_service_areas_new_model'].reenable
      # end new model
    end
    puts "*"*80 unless Rails.env.test?
  end

  task :update_service_areas_new_model, [:file] => :environment do |t,args|
    row_data_begin = 13
    total = 0
    begin
      file = args[:file]
      @year = 2019

      xlsx = Roo::Spreadsheet.open(file)
      sheet = xlsx.sheet(0)
      issuer_hios_id = sheet.cell(6,2).to_i.to_s
      (row_data_begin..sheet.last_row).each do |i|
        serves_entire_state = to_boolean(sheet.cell(i,3))
        serves_partial_county = serves_entire_state ? nil : to_boolean(to_boolean(sheet.cell(i,5)))
        if serves_entire_state
          sa = ::Locations::ServiceArea.where(
            active_year: @year,
            issuer_provided_code: sheet.cell(i,1),
            covered_states: ["MA"],
            issuer_provided_title: sheet.cell(i,2)
          ).first
          if sa.present?
            sa.issuer_hios_id = issuer_hios_id
            sa.save
          else
            ::Locations::ServiceArea.create(
              active_year: @year,
              issuer_provided_code: sheet.cell(i,1),
              covered_states: ["MA"],
              issuer_hios_id: issuer_hios_id,
              issuer_provided_title: sheet.cell(i,2)
            )
          end
        elsif serves_entire_state == false
          existing_state_wide_areas = ::Locations::ServiceArea.where(
            active_year: @year,
            issuer_provided_code: sheet.cell(i,1),
            # issuer_hios_id: issuer_hios_id,
            # covered_states: nil
          )
          if existing_state_wide_areas.count > 0 && existing_state_wide_areas.first.covered_states.present? && existing_state_wide_areas.first.covered_states.include?("MA")
            v = existing_state_wide_areas.first
            v.issuer_hios_id = issuer_hios_id
            v.save
          else

            county_name, state_code, county_code = extract_county_name_state_and_county_codes(sheet.cell(i,4))

            records = ::Locations::CountyZip.where({county_name: county_name})

            if sheet.cell(i,6).present?
              extracted_zips = extracted_zip_codes(sheet.cell(i,6)).each {|t| t.squish!}
              records = records.where(:zip.in => extracted_zips)
            end

            location_ids = records.map(&:_id).uniq.compact

            if existing_state_wide_areas.count > 0
              v = existing_state_wide_areas.first
              v.county_zip_ids << location_ids
              v.county_zip_ids = v.county_zip_ids.flatten.uniq
              v.issuer_hios_id = issuer_hios_id
              v.save
            else
              ::Locations::ServiceArea.create({
                active_year: @year,
                issuer_provided_code: sheet.cell(i,1),
                issuer_hios_id: issuer_hios_id,
                issuer_provided_title: sheet.cell(i,2),
                county_zip_ids: location_ids
              })
            end
          end
        end
      end

    rescue => e
      puts e.inspect unless Rails.env.test?
      puts " --------- " unless Rails.env.test?
      puts e.backtrace unless Rails.env.test?
    end

  end

  private

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
