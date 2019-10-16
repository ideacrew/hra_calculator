# frozen_string_literal: true

module Locations::Transactions
  class SearchForServiceArea
    include Dry::Transaction

    step :find_tenant
    step :search_for_county_zips
    step :fetch_service_areas

    private

    def find_tenant(params)
      @tenant = Tenants::Tenant.find_by_key(params[:tenant])
      Success(params)
    end

    def search_for_county_zips(params)
      return Success([]) if @tenant.geographic_rating_area_model == 'single'

      county_name = params[:county].blank? ? "" : params[:county].titlecase
      zip_code = params[:zipcode]
      year = params[:start_month].year
      state_abbreviation = params[:tenant].to_s.upcase

      query_criteria = {
        :county_name => county_name,
        :state => state_abbreviation
      }
      query_criteria.merge!({:zip => zip_code}) if @tenant.geographic_rating_area_model == 'zipcode'
      county_zip_ids = ::Locations::CountyZip.where(query_criteria).pluck(:id).uniq
      Success({year: year, county_zip_ids: county_zip_ids, state_abbreviation: state_abbreviation})
    end

    def fetch_service_areas(input_hash)
      return Success([]) if @tenant.geographic_rating_area_model == 'single'

      service_area_ids = ::Locations::ServiceArea.where(
        "active_year" => input_hash[:year],
        "$or" => [
          {"county_zip_ids" => { "$in" => input_hash[:county_zip_ids] }},
          {"covered_states" =>  input_hash[:state_abbreviation]}
        ]
      ).pluck(:_id).map(&:to_s)
      return Success(service_area_ids) if service_area_ids.present?

      Failure({errors: ['Could Not find Service Areas for the given data']})
    end
  end
end
