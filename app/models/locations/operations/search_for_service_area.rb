# frozen_string_literal: true

module Locations::Operations
  class SearchForServiceArea
    include Dry::Transaction::Operation
    include ::SettingsHelper

    def call(hra_object)
      county_name = hra_object.county.blank? ? "" : hra_object.county.titlecase
      zip_code = hra_object.zipcode
      year = hra_object.start_month.year

      county_zip_ids = ::Locations::CountyZip.where(
        :county_name => county_name,
        :zip => zip_code,
        :state => state_abbreviation
      ).pluck(:id).uniq

      service_areas = ::Locations::ServiceArea.where(
        "active_year" => year,
        "$or" => [
          {"county_zip_ids" => { "$in" => county_zip_ids }},
          {"covered_states" =>  state_abbreviation}
        ]
      )

      return Success(service_areas) if service_areas.present?

      hra_object.errors += ['Could Not find Service Areas for the given data']
      Failure(hra_object)
    end
  end
end