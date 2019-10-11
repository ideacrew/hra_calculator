# frozen_string_literal: true

module Locations::Operations
  class SearchForRatingArea
    include Dry::Transaction::Operation

    def call(hra_object)
      county_name = hra_object.county.blank? ? "" : hra_object.county.titlecase
      zip_code = hra_object.zipcode
      year = hra_object.start_month.year
      state_abbreviation = hra_object.tenant.to_s.upcase
      tenant = Tenants::Tenant.find_by_key(hra_object.tenant)
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

      return Success(rating_area) if rating_area.present?

      hra_object.errors += ['Could Not find Rating Area for the given data']
      Failure(hra_object)
    end
  end
end