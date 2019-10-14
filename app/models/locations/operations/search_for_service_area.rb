# frozen_string_literal: true

module Locations::Operations
  class SearchForServiceArea
    include Dry::Transaction::Operation

    def call(params)
      county_name = params[:county].blank? ? "" : params[:county].titlecase
      zip_code = params[:zipcode]
      year = params[:start_month].year
      state_abbreviation = params[:tenant].to_s.upcase
      tenant = Tenants::Tenant.find_by_key(params[:tenant])
      return Success([]) if tenant.geographic_rating_area_model == 'single'

      query_criteria = {
        :county_name => county_name,
        :state => state_abbreviation
      }
      query_criteria.merge!({:zip => zip_code}) if tenant.geographic_rating_area_model == 'zipcode'
      county_zip_ids = ::Locations::CountyZip.where(query_criteria).pluck(:id).uniq
      service_area_ids = ::Locations::ServiceArea.where(
        "active_year" => year,
        "$or" => [
          {"county_zip_ids" => { "$in" => county_zip_ids }},
          {"covered_states" =>  state_abbreviation}
        ]
      ).pluck(:_id).map(&:to_s)
      return Success(service_area_ids) if service_area_ids.present?

      Failure({errors: ['Could Not find Service Areas for the given data']})
    end
  end
end