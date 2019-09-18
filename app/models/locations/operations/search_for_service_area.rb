# frozen_string_literal: true

module Locations::Operations
  class SearchForServiceArea
    include Dry::Transaction::Operation

    def call(hra_object)
      county_name = hra_object.county.blank? ? "" : hra_object.county.titlecase
      zip_code = hra_object.zipcode
      state_abbrev = 'MA' # TODO: Read this from Settings.
      year = hra_object.start_month.year

      # TODO: refactor this for states with zip vs without zip
      county_zip_ids = ::Locations::CountyZip.where(
        :county_name => county_name,
        :zip => zip_code,
        :state => state_abbrev
      ).pluck(:id).uniq

      service_area = ::Locations::ServiceArea.where(
        "active_year" => year,
        "$or" => [
          {"county_zip_ids" => { "$in" => county_zip_ids }},
          {"covered_states" =>  state_abbrev}
        ]
      ).first

      # TODO: Remove this once Service areas are properly loaded
      service_area ||= ::Locations::ServiceArea.all.first

      return Success(service_area) if service_area.present?

      hra_object.errors << 'Could Not find Service Area for the given data'
      Failure(hra_object)
    end
  end
end