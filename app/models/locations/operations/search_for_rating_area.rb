# frozen_string_literal: true

module Locations::Operations
  class SearchForRatingArea
    include Dry::Transaction::Operation

    def call(hra_object)
      county_name = hra_object.county.blank? ? "" : hra_object.county.titlecase
      zip_code = hra_object.zip_code
      state_abbrev = 'MA' # TODO: Read this from Settings.
      year = hra_object.start_month.year

      county_zip_ids = ::Locations::CountyZip.where(
        :zip => zip_code,
        :county_name => county_name,
        :state => state_abbrev
      ).map(&:id)

      rating_area = ::Locations::RatingArea.where(
        "active_year" => year,
        "$or" => [
          {"county_zip_ids" => { "$in" => county_zip_ids }},
          {"covered_states" => state_abbrev}
        ]
      ).first

      # TODO: Refactor to handle failure case
      rating_area ||= ::Locations::RatingArea.all.first
      Success(rating_area)
    end
  end
end