module Transactions
  class SerffTemplateUpload
    include Dry::Transaction

    step :validate
    step :feature_questions_answered
    step :check_for_zip
    step :unzip_serff
    step :validate_and_assign_serff_folder_and_files # Every Folder should have expected files
    step :process_for_countyzips # This step is for Tenants with geographic_rating_area_model as COUNTY.
    step :process_countyzip_file # This step is for Tenants with geographic_rating_area_model as ZIPCODE.
    step :process_serff_templates

    private

    def validate(input)
      @tenant = ::Tenants::Tenant.find(input['tenant_id'])
      @year = input['admin']['benefit_year']

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
        Failure({errors: ["Uploaded file: #{file_name} is not a zip file "]})
      end
    end

    def unzip_serff(input)
      begin
        zip_file_s = input['serff_template']['value'].tempfile
        @destination = "#{Rails.root}/tmp/load_plan"
        FileUtils.rm_rf(@destination) if File.directory?(@destination) # Deletes existing folder.
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

    def validate_and_assign_serff_folder_and_files(path)
      # path = "#{Rails.root}/tmp/load_plan/serff_template"
      begin
        @sa_paths = []
        @county_zip_files = []
        carrier_directories = Dir.glob(File.join(path, "*"))
        carrier_directories.each do |directory_content|
          # TODO: remove duplicate code
          if File.directory?(directory_content)
            carrier_name = File.basename(directory_content)
            xml_files = Dir.glob(File.join(directory_content, "*"))
            service_area_file = xml_files.select{|file| File.basename(file) == "service_areas.xlsx" }.first
            plan_file = xml_files.select{|file| File.basename(file) == "plan_and_benefits.xml" }.first
            rates_file = xml_files.select{|file| File.basename(file) == "rates.xml" }.first

            @sa_paths << service_area_file

            errors = []
            errors << "Plan XML doesnot exist for carrier: #{carrier_name}" if !plan_file
            errors << "Rates XML doesnot exist for carrier: #{carrier_name}" if !rates_file
            errors << "Service Area file doesnot exist for carrier: #{carrier_name}" if !@tenant.geographic_rating_area_model == 'single' && !service_area_file

            return Failure({errors: errors}) if errors.present?
          else
            @county_zip_files << directory_content if File.extname(directory_content) == '.xlsx'
          end
        end

        if @tenant.geographic_rating_area_model == 'zipcode'
          if @county_zip_files.count == 1
            cz_file_contract = ::Validations::CountyZipFileContract.new.call({county_zip_file: @county_zip_files.first})

            if cz_file_contract.failure?
              return Failure({errors: ["#{cz_file_contract.errors.to_h.first.first.to_s} #{cz_file_contract.errors.to_h.first.second.first}"]})
            end
          else
            return Failure({errors: ["Given serff_templates folder has more than one file in .xlsx format"]})
          end
        end
      rescue
        return Failure({errors: ["Unable to read data from the uploaded zipfile"]})
      end
      Success(path)
    end

    # This step is for Tenants with geographic_rating_area_model as COUNTY.
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

    # This step is for Tenants with geographic_rating_area_model as ZIPCODE.
    def process_countyzip_file(input_path)
      return Success(input_path) unless @tenant.geographic_rating_area_model == 'zipcode'

      params = { file: @county_zip_files.first, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
      cz_process_result = Transactions::CountyZipFile.new.call(params)
      if cz_process_result.success?
        Success(input_path)
      else
        destroy_countyzips(tenant, import_timestamp)
        Failure({errors: ["Unable to create CountyZips/RatingArea for given counties per #{params[:file]}"]})
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
      ::Locations::RatingArea.where({created_at: import_timestamp}).all.destroy_all
      ::Locations::CountyZip.where({created_at: import_timestamp,state: tenant.key.to_s.upcase}).all.destroy_all
    end

    def destory_created_objects(import_timestamp)
      @tenant.products.where(created_at: import_timestamp).destroy_all
      ::Locations::ServiceArea.all.where(created_at: import_timestamp).destroy_all
    end
  end
end
