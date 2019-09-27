namespace :import do
  task :county_zips, [:file] => :environment do |task, args|
    include ::SettingsHelper

    files = Rails.env.test? ? [args[:file]] : Dir.glob(File.join(Rails.root, "db/seedfiles/plan_xmls/ma/xls_templates/", "SHOP_ZipCode_CY2017_FINAL.xlsx"))
    count = 0
    files.each do |file|
      year = 2020
      puts "*"*80 unless Rails.env.test?
      puts "Importing county, zips from #{file}..." unless Rails.env.test?
      if file.present?
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
          count+=1
        end
      end
    end
    puts "*"*80 unless Rails.env.test?
    puts "successfully created #{count} county, zip records" unless Rails.env.test?
    puts "*"*80 unless Rails.env.test?
  end

  def assign_headers
    @headers = Hash.new
    @header_row.each_with_index {|header,i|
      @headers[header.to_s.underscore] = i
    }
    @headers
  end
end