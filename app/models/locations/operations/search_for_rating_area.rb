# frozen_string_literal: true

module Locations::Operations
  class SearchForRatingArea
    include Dry::Transaction::Operation

    def call(params)
      tenant = Tenants::Tenant.find_by_key(params[:tenant])
      return Success(nil) if tenant.geographic_rating_area_model == 'single'

      county_name = params[:county].blank? ? "" : params[:county].titlecase
      zip_code = params[:zipcode]
      year = params[:start_month].year
      state_abbreviation = params[:tenant].to_s.upcase
      query_criteria = {
        :state => state_abbreviation,
        :county_name => county_name
      }
      query_criteria.merge!({:zip => zip_code}) if tenant.geographic_rating_area_model == 'zipcode'
      county_zip_ids = ::Locations::CountyZip.where(query_criteria).pluck(:id).uniq
      rating_area = ::Locations::RatingArea.where(
        "active_year" => year,
        "$or" => [
          {"county_zip_ids" => { "$in" => county_zip_ids }},
          {"covered_states" => state_abbreviation}
        ]
      ).first
      return Success(rating_area.id.to_s) if rating_area.present?

      Failure({errors: ['Unable to find Rating Area for given data']})
    end
  end
end
