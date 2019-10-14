module Transactions
  class CountyZipFile
    include Dry::Transaction

    step :persist

    private

    def persist(params)
      # params = { file: @county_zip_files.first, tenant: @tenant, year: @year, import_timestamp: @import_timestamp }
      @tenant = params[:tenant]
      return Success("CountyZips not needed") if @tenant.geographic_rating_area_model == 'single'
      county_zip_initial_count = Locations::CountyZip.all.count
      county_zip_result = ::Operations::ImportCountyZip.new.call(params)
      if county_zip_result.success?
        county_zip_final_count    = Locations::CountyZip.all.count
        rating_area_initial_count = Locations::RatingArea.all.count
        rating_area_result = ::Operations::ImportRatingArea.new.call(params)
        rating_area_final_count = Locations::RatingArea.all.count

        if rating_area_result.failure?
          return Failure({errors: ["#{rating_area_result.failure[:errors]}"]})
        else
          Success("Successfully created #{county_zip_final_count-county_zip_initial_count} CountyZip and #{rating_area_final_count - rating_area_initial_count} RatingArea records")
        end
      else
        Failure({errors: ["#{county_zip_result.failure[:errors]}"]})
      end
    end
  end
end
