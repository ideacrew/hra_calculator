module Products::Operations
  class FetchProducts
    include Dry::Transaction::Operation

    def call(params)
      date = params[:date]
      service_area_id = params[:service_area_id]
      rating_area_id = params[:rating_area_id]
      products = ::Products::Product.where(
        :premium_tables.exists => true,
        :"premium_tables.premium_tuples".exists => true,
        service_area_id: service_area_id,
        :"premium_tables.rating_area_id" => rating_area_id,
        :"premium_tables.effective_period.min".lte => date,
        :"premium_tables.premium_tuples.age" => age)

      Success(products)
    end
  end
end
