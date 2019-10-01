module Transactions
  class CountyZipFile
    include Dry::Transaction

    step :fetch
    step :feature_questions_answered
    step :validate
    step :persist

    private

    def fetch(input)
      @tenant = ::Tenants::Tenant.find(input['tenant_id'])
      @year = input['county_zip_year']
      return Failure({errors: ['Please upload a file']}) if input['county_zip'].nil?

      action_dispatch = input['county_zip']['value']
      return Failure({errors: ['Uploaded file is not in the expected format']}) if File.extname(action_dispatch.original_filename) != ".xlsx"

      file = action_dispatch.tempfile.path
      if @tenant.blank?
        Failure({errors: {tenant_id: "Unable to find tenant record with id #{input[:id]}"}})
      elsif @year.blank?
        Failure({errors: {year: "Please select a valid year"}})
      else
        Success({county_zip_file: file})
      end
    end

    def feature_questions_answered(input)
      return Failure({errors: ["Please answer the questions in the features page"]}) if !@tenant.geographic_rating_area_model || !@tenant.use_age_ratings

      Success(input)
    end

    def validate(input)
      output = ::Validations::CountyZipFileContract.new.call(input)

      if output.failure?
        result = output.to_h
        result[:errors] = []
        output.errors.to_h.each_pair do |keyy, val|
          result[:errors] << "#{keyy.to_s} #{val.first}"
        end
        Failure(result)
      else
        Success(output)
      end
    end

    def persist(input)
      params = { file: input.to_h[:county_zip_file], tenant: @tenant, year: @year }
      return Success("CountyZips not needed") unless @tenant.geographic_rating_area_model == 'zipcode'

      county_zip_result = ::Operations::ImportCountyZip.new.call(params)
      if county_zip_result.success?
        rating_area_result = ::Operations::ImportRatingArea.new.call(params)
        if rating_area_result.failure?
          return Failure({errors: ["#{rating_area_result.failure[:errors]}"]})
        else
          Success("created CountyZips/RatingArea")
        end
      else
        Failure({errors: ["#{county_zip_result.failure[:errors]}"]})
      end
    end
  end
end
