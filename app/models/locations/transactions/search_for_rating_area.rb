# frozen_string_literal: true

module Locations::Transactions
  class SearchForRatingArea
    include Dry::Transaction

    step :find_tenant
    step :search_for_county_zips
    step :fetch_rating_area

    private

    def find_tenant(params)
      @tenant = Tenants::Tenant.find_by_key(params[:tenant])
      Success(params)
    end

    def search_for_county_zips(params)
      return Success(nil) if @tenant.geographic_rating_area_model == 'single'

      county_name = params[:county].blank? ? "" : params[:county].titlecase
      zip_code = params[:zipcode]
      year = params[:start_month].year
      state_abbreviation = params[:tenant].to_s.upcase
      query_criteria = {
        :state => state_abbreviation,
        :county_name => county_name
      }
      query_criteria.merge!({:zip => zip_code}) if @tenant.geographic_rating_area_model == 'zipcode'
      county_zip_ids = ::Locations::CountyZip.where(query_criteria).pluck(:id).uniq

      Success({county_zip_ids: county_zip_ids, year: year, state_abbreviation: state_abbreviation})
    end

    def fetch_rating_area(input_hash)
      return Success(nil) if @tenant.geographic_rating_area_model == 'single'

      rating_area = ::Locations::RatingArea.where(
        "active_year" => input_hash[:year],
        "$or" => [
          {"county_zip_ids" => { "$in" => input_hash[:county_zip_ids] }},
          {"covered_states" => input_hash[:state_abbreviation]}
        ]
      ).first
      return Success(rating_area.id.to_s) if rating_area.present?

      Failure({errors: ['Unable to find Rating Area for given data']})
    end
  end
end
