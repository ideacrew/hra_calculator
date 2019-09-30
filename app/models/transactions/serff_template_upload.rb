module Transactions
  class SerffTemplateUpload
    include Dry::Transaction

    step :validate
    step :check_for_zip
    step :unzip_serff
    step :validate_serff_folder_and_files # Every Folder should have expected files
    step :process_serff_templates

    private

    def validate(input)
      @tenant = ::Tenants::Tenant.find(input['tenant_id'])
      @year = input['serff_year']

      if @tenant.blank?
        Failure({errors: ["Unable to find tenant record with id #{input['tenant_id']}"]})
      elsif @year.blank?
        Failure({errors: ["Please select a valid year"]})
      else
        Success(input)
      end
    end

    def check_for_zip(input)
      file_name = input['serff_template']['value'].original_filename
      if File.extname(file_name) == ".zip"
        Success(input)
      else
        Failure({errors: ["Uploaded file is not in expected format: #{file_name}"]})
      end
    end

    def unzip_serff(input)
      begin
        # TODO: Test this for unzipping as per sub-folders
        zip_file_s = input['serff_template']['value'].tempfile
        @destination = "#{Rails.root}/tmp/load_plan"
        FileUtils.rm_rf(@destination) if File.directory?(@destination)
        FileUtils.mkdir_p(@destination)

        Zip::File.open(zip_file_s) { |zip_file|
          zip_file.each { |f|
            f_path = File.join(@destination, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          }
        }
        path = "#{@destination}/serff_templates"

        if Dir.empty?(path)
          return Failure({errors: ["Uploaded folder if empty serff_template"]})
        else
          return Success(path)
        end
      rescue
        Failure(errors: ["Unable to unzip the give file"])
      end
    end

    def validate_serff_folder_and_files(path)
      # path = "#{Rails.root}/tmp/load_plan/serff_template"
      begin
        carrier_directories = Dir.glob(File.join(path, "*"))
        carrier_directories.each do |carrier_directory|
          # TODO: remove duplicate code
          next if File.file?(carrier_directory)

          carrier_name = File.basename(carrier_directory)
          xml_files = Dir.glob(File.join(carrier_directory, "*.xml"))
          service_area_file = xml_files.select{|file| File.basename(file) == "service_areas.xml" }.first
          plan_file = xml_files.select{|file| File.basename(file) == "plan_and_benefits.xml" }.first
          rates_file = xml_files.select{|file| File.basename(file) == "rates.xml" }.first

          errors = []
          errors << "Plan XML doesnot exist for carrier: #{carrier_name}" if !plan_file
          errors << "Rates XML doesnot exist for carrier: #{carrier_name}" if @tenant.use_age_ratings == 'age_rated' && !rates_file
          errors << "Service Area file doesnot exist for carrier: #{carrier_name}" if !@tenant.geographic_rating_area_model == 'single' && !service_area_file

          return Failure({errors: errors}) if errors.present?
        end
      rescue
        return Failure({errors: ["Unable to read data from the uploaded zipfile"]})
      end
      Success(path)
    end

    def process_serff_templates(input_path)
      # input_path = "#{Rails.root}/db/seedfiles/plan_xmls/serff_templates/"
      @import_timestamp = DateTime.now
      carrier_directories = Dir.glob(File.join(input_path, "*"))
      carrier_directories.each do |carrier_directory|
        # TODO: remove duplicate code
        next if File.file?(carrier_directory)

        @carrier_name = File.basename(carrier_directory)
        xml_files = Dir.glob(File.join(carrier_directory, "*.xml"))
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

        import_serff_files_result = ::Transactions::ImportSerffFiles.new.call(serff_params)

        if import_serff_files_result.failure?
          destory_created_objects(@import_timestamp)
          return Failure({errors: import_serff_files_result.failure[:errors]})
        end
      end

      Success("New All service areas and plans got uploaded")
    end

    def destory_created_objects(import_timestamp)
      @tenant.products.where(created_at: import_timestamp).destroy_all
      ::Locations::ServiceArea.all.where(created_at: import_timestamp).destroy_all
      # Products and ServiceAreas
    end
  end
end
