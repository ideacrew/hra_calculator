module Transactions
  class UploadSerffTemplate
    include Dry::Transaction

    step :check_for_zip
    step :fetch
    step :unzip_serff
    step :assign_paths
    step :validate
    step :persist_service_area
    step :persist_plan
    step :persist_rates

    private

    def check_for_zip(input)
      if File.extname(input['serff_template']['value'].original_filename) == ".zip"
        Success(input)
      else
        Failure('Uploaded file is not in expected format')
      end
    end

    def fetch(input)
      @tenant = ::Tenants::Tenant.find(input['tenant_id'])
      @year = input['serff_year']

      if @tenant.blank?
        Failure({errors: {tenant_id: "Unable to find tenant record with id #{input[:id]}"}})
      elsif @year.blank?
        Failure({errors: {year: "Unable to year"}})
      else
        Success(input)
      end
    end

    def unzip_serff(input)
      zip_file_s = input['serff_template']['value'].tempfile
      destination = "#{Rails.root}/tmp/load_plan"
      FileUtils.rm_rf(destination) if File.directory?(destination)
      FileUtils.mkdir_p(destination)

      Zip::File.open(zip_file_s) { |zip_file|
        zip_file.each { |f|
          f_path = File.join(destination, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        }
      }

      path = "#{destination}/serff_template"

      if Dir.empty?(path)
        Failure("The required directory is empty")
      else
        Success(path)
      end
    end

    def assign_paths(input)
      files = Dir.glob(File.join(input, "*"))
      @service_area_file = files.select{|file| file.include?("_SA_") && File.extname(file) == ".xlsx"}.first
      @plan_file = files.select{|file| file.include?("_PB_") && File.extname(file) == ".xml"}.first
      @rates_file = files.select{|file| file.include?("_RATES_") && File.extname(file) == ".xml"}.first

      if @service_area_file && @plan_file && @rates_file
        Success({
          service_area: @service_area_file,
          plan: @plan_file,
          rate: @rates_file
        })
      else
        Failure("Unable to find files or files with required format")
      end
    end

    def validate(input)
      output = ::Validations::SerffUploadContract.new.call(input)

      if output.failure?
        result = output.to_h
        result[:errors] = []
        output.errors.to_h.each_pair do |keyy, val|
          result[:errors] << "#{keyy.to_s} #{val.first}"
        end
        Failure(result)
      else
        Success(@service_area_file)
      end
    end

    def persist_service_area(input)
      params = { sa_file: input, tenant: @tenant, year: @year }
      result = ::Operations::ImportServiceArea.new.call(params)

      if result.success?
        Success(@plan_file)
      else
        Failure({errors: ['Unable to create Service Area']})
      end
    end

    def persist_plan(input)
      params = { plan_file: input, tenant: @tenant, year: @year }
      result = ::Operations::CreatePlan.new.call(params)

      if result.success?
        Success(@rates_file)
      else
        Failure({errors: ['Unable to create Service Area']})
      end
    end

    def persist_rates(input)
      params = { rates_file: input, tenant: @tenant, year: @year }
      result = ::Operations::CreateRates.new.call(params)

      if result.success?
        Success('Successfully created plans and rates')
      else
        Failure({errors: ['Unable to create Service Area']})
      end
    end
  end
end
