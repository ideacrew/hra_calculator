module Transactions
  class SerffTemplateUpload
    include Dry::Transaction

    step :validate
    step :feature_questions_answered
    step :check_for_zip
    step :unzip_serff
    step :validate_serff_folder_and_files # Every Folder should have expected files
    step :process_for_countyzips
    step :process_serff_templates

    private

    def validate(input)
      @tenant = ::Tenants::Tenant.find(input['tenant_id'])
      @year = input['serff_year']

      if @tenant.blank?
        Failure({errors: ["Unable to find tenant record with id #{input['tenant_id']}"]})
      elsif !::Enterprises::BenefitYear.pluck(:calendar_year).map(&:to_s).include?(@year)
        Failure({errors: ["Please select a valid year"]})
      else
        Success(input)
      end
    end

    def feature_questions_answered(input)
      return Failure({errors: ["Please answer the questions in the features page"]}) if !@tenant.geographic_rating_area_model || !@tenant.use_age_ratings

      Success(input)
    end

    def check_for_zip(input)
      return Failure({errors: ['Please upload a file']}) if input['serff_template'].nil?

      file_name = input['serff_template']['value'].original_filename
      if File.extname(file_name) == ".zip"
        Success(input)
      else
        Failure({errors: ["Uploaded file is not in expected format: #{file_name}"]})
      end
    end

    def unzip_serff(input)
      begin
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
      rescue
        return Failure({errors: ["Unable to unzip the given file"]})
      end

      path = "#{@destination}/serff_templates"
      return Failure({errors: ["Uploaded zip file does not have serff_templates folder"]}) unless File.directory?(path)

      if Dir.empty?(path)
        return Failure({errors: ["serff_templates folder is empty"]})
      else
        return Success(path)
      end
    end

    def validate_serff_folder_and_files(path)
      # path = "#{Rails.root}/tmp/load_plan/serff_template"
      begin
        @sa_paths = []
        carrier_directories = Dir.glob(File.join(path, "*"))
        carrier_directories.each do |carrier_directory|
          # TODO: remove duplicate code
          next if File.file?(carrier_directory)

          carrier_name = File.basename(carrier_directory)
          xml_files = Dir.glob(File.join(carrier_directory, "*"))
          service_area_file = xml_files.select{|file| File.basename(file) == "service_areas.xlsx" }.first
          plan_file = xml_files.select{|file| File.basename(file) == "plan_and_benefits.xml" }.first
          rates_file = xml_files.select{|file| File.basename(file) == "rates.xml" }.first

          @sa_paths << service_area_file

          errors = []
          errors << "Plan XML doesnot exist for carrier: #{carrier_name}" if !plan_file
          errors << "Rates XML doesnot exist for carrier: #{carrier_name}" if !rates_file
          errors << "Service Area file doesnot exist for carrier: #{carrier_name}" if !@tenant.geographic_rating_area_model == 'single' && !service_area_file

          return Failure({errors: errors}) if errors.present?
        end
      rescue
        return Failure({errors: ["Unable to read data from the uploaded zipfile"]})
      end
      Success(path)
    end

    def process_for_countyzips(input_path)
      @import_timestamp = DateTime.now
      return Success(input_path) unless @tenant.geographic_rating_area_model == 'county'

      cz_params = { cz_files: @sa_paths, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
      icz_result = ::Operations::StoreCountyZip.new.call(cz_params)

      if icz_result.success?
        Success(input_path)
      else
        destroy_countyzips(@tenant, @import_timestamp)
        Failure({errors: ["Unable to create CountyZips for given counties per SA serff_templates"]})
      end
    end

    def process_serff_templates(input_path)
      # input_path = "#{Rails.root}/db/seedfiles/plan_xmls/serff_templates/"
      carrier_directories = Dir.glob(File.join(input_path, "*"))
      carrier_directories.each do |carrier_directory|
        # TODO: remove duplicate code
        next if File.file?(carrier_directory)

        @carrier_name = File.basename(carrier_directory)
        xml_files = Dir.glob(File.join(carrier_directory, "*"))
        @service_area_file = xml_files.select{|file| File.basename(file) == "service_areas.xlsx" }.first
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

    def destroy_countyzips(tenant, import_timestamp)
      # TODO: destroy countyzips that got created.
    end

    def destory_created_objects(import_timestamp)
      @tenant.products.where(created_at: import_timestamp).destroy_all
      ::Locations::ServiceArea.all.where(created_at: import_timestamp).destroy_all
      # Products and ServiceAreas
    end
  end
end
