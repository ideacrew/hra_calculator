# frozen_string_literal: true

module Locations::Operations
  class SearchForServiceArea
    include Dry::Transaction::Operation

    def call(hra_object)
      county_name = hra_object.county.blank? ? "" : hra_object.county.titlecase
      zip_code = hra_object.zip_code
      state_abbrev = 'MA' # TODO: Read this from Settings.
      year = hra_object.start_month.year

      county_zip_ids = ::BenefitMarkets::Locations::CountyZip.where(
        :county_name => county_name,
        :zip => zip_code,
        :state => state_abbrev
      ).map(&:id).uniq

      service_area = ::Locations::ServiceArea.where(
        "active_year" => year,
        "$or" => [
          {"county_zip_ids" => { "$in" => county_zip_ids }},
          {"covered_states" =>  state_abbrev}
        ]
      )

      # TODO: Refactor to handle Failure case
      service_area ||= ::Locations::ServiceArea.all.first
      Success(service_area)
    end
  end
end