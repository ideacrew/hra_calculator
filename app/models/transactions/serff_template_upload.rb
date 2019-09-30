module Transactions
  class SerffTemplateUpload
    include Dry::Transaction

    step :unzip_serff
    step :validate_serff_folder_and_files # Every Folder should have expected files
    step :process_serff_templates

    private

    def process_serff_templates(parmas)
      @tenant = ::Tenants::Tenant.all.first
      @import_timestamp = DateTime.now
      @year = 2020

      input = "#{Rails.root}/db/seedfiles/plan_xmls/serff_templates/"
      directories = Dir.glob(File.join(input, "*"))
      directories.each do |directory|
        next if File.file?(directory)

        @carrier_name = File.basename(directory)
        xml_files = Dir.glob(File.join(directory, "*.xml"))
        @service_area_file = xml_files.select{|file| File.basename(file) == "service_areas.xml" }.first
        @plan_file = xml_files.select{|file| File.basename(file) == "plan_and_benefits.xml" }.first
        @rates_file = xml_files.select{|file| File.basename(file) == "rates.xml" }.first
        serff_params = { service_area_file: @service_area_file,
                         plans_file: @plan_file,
                         rates_file: @rates_file,
                         import_timestamp: @import_timestamp,
                         tenant: @tenant,
                         year: @year,
                         carrier_name: @carrier_name
                       }

        begin
          import_serff_files_result = ::Transactions::ImportSerffFiles.new.call(serff_params)

          if import_serff_files_result.failure?
            destory_created_objects(@import_timestamp)
            errors = ["some file has bad data"] # import_serff_files_result.failure.to_h
            return Failure(errors)
          end
        rescue => e
          destory_created_objects(@import_timestamp)
          errors = ["some file has bad data"] # import_serff_files_result.failure.to_h
        end
      end

      Success("New All service areas and plans got uploaded")
    end

    def destory_created_objects(import_timestamp)
      # Products and ServiceAreas
    end
  end
end
