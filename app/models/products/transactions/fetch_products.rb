# frozen_string_literal: true

module Products::Transactions
  class FetchProducts
    include Dry::Transaction

    step :fetch_service_area_ids
    step :plan_criteria

    private

    def fetch_service_area_ids(params)
      service_areas_result = ::Locations::Operations::SearchForServiceArea.new.call(params)

      if service_areas_result.success
        Success(params.merge!({service_area_ids: service_areas_result.success}))
      else
        Failure(params.merge!(service_areas_result.failure))
      end
    end

    def plan_criteria(params)
      tenant = Tenants::Tenant.find_by_key(params[:tenant])
      query_criteria = {
        :premium_tables.exists => true,
        :"premium_tables.premium_tuples".exists => true,
        :"premium_tables.effective_period.min".lte => params[:start_month],
        :"premium_tables.effective_period.max".gte => params[:start_month]
      }

      if tenant.geographic_rating_area_model == 'county'
        query_criteria.merge!({
          :"service_area_id".in => params[:service_area_ids]
        })
      elsif tenant.geographic_rating_area_model == 'zipcode'
        query_criteria.merge!({
          :"service_area_id".in => params[:service_area_ids],
          :"premium_tables.rating_area_id" => BSON::ObjectId.from_string(params[:rating_area_id])
        })
      end

      products = tenant.products.where(query_criteria)
      return Success(products) if products.present?

      Failure({errors: ['Could Not find any Products for the given data']})
    end
  end
end
